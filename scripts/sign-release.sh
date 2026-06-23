#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

: "${GH_TOKEN:?Environment variable must be set}"
: "${REPO:?Environment variable must be set}"
: "${TAG:?Environment variable must be set}"
: "${GPG_PASSPHRASE:?Environment variable must be set}"
: "${GPG_KEY_NAME:?Environment variable must be set}"

main() {
    cd "$(mktemp -d)"

    local assets tgz
    assets=$(gh release view "$TAG" --repo "$REPO" --json assets --jq '.assets[].name')
    tgz=$(grep -E '\.tgz$' <<< "$assets" || true)

    if [[ -z "$tgz" ]]; then
        echo "No .tgz asset on release $TAG; nothing to sign."
        exit 0
    fi

    local prov="${tgz}.prov"
    if grep -qxF "$prov" <<< "$assets"; then
        echo "$prov already signed on release $TAG; skipping."
        exit 0
    fi

    echo "Signing $tgz"
    gh release download "$TAG" --repo "$REPO" --pattern "$tgz"

    # A Helm provenance is the chart's Chart.yaml, a "..." YAML separator, then
    # the archive's SHA-256.
    local digest chart_dir
    digest=$(sha256sum "$tgz" | awk '{print $1}')
    chart_dir=$(tar -tzf "$tgz" | awk -F/ 'NR==1 {print $1}')
    {
        tar -xzOf "$tgz" "${chart_dir}/Chart.yaml"
        printf '\n...\nfiles:\n  %s: sha256:%s\n' "$tgz" "$digest"
    } > provenance.txt

    gpg --batch --yes --pinentry-mode loopback \
        --passphrase "$GPG_PASSPHRASE" \
        --local-user "$GPG_KEY_NAME" \
        --digest-algo SHA256 \
        --clearsign --output "$prov" provenance.txt

    # Verify the signature against our public key before publishing it.
    gpg --batch --yes --export "$GPG_KEY_NAME" > pubring.gpg
    helm verify --keyring pubring.gpg "$tgz"

    gh release upload "$TAG" "$prov" --repo "$REPO"
    echo "Uploaded $prov"
}

main

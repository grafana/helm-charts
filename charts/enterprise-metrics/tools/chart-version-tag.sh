#!/usr/bin/env bash

set -o nounset
set -o pipefail

RELEASE_TAG=$(git describe --tags --exact-match 2>/dev/null)
set -o errexit
if [ -z "$RELEASE_TAG" ]
then
    WORKING_SUFFIX=$(if git status --porcelain | grep -qE '^(?:[^?][^ ]|[^ ][^?])\s'; then echo "-WIP"; else echo ""; fi)
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
    TAG_PREFIX=$(git describe --tags 2>/dev/null)    
    echo "$TAG_PREFIX-${BRANCH_NAME//\//-}$WORKING_SUFFIX"
else
    echo "$RELEASE_TAG"
fi
#!/bin/bash

# renovate: datasource=github-tags depName=mikefarah/yq
export YQ_VERSION=v4.40.5

# renovate: datasource=github-tags depName=jenkins-x-plugins/jx-release-version
export JENKINS_JX_VERSION=v2.7.3

# renovate: datasource=github-releases depName=helm-docs packageName=norwoodj/helm-docs
export HELM_DOCS_VERSION=1.13.1

curl -fsSL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64
chmod a+x /usr/local/bin/yq

curl -fsSL -o /tmp/jx-release.tar.gz https://github.com/jenkins-x-plugins/jx-release-version/releases/download/${JENKINS_JX_VERSION}/jx-release-version-linux-amd64.tar.gz
mkdir -p /tmp/jx && tar -xf /tmp/jx-release.tar.gz -C /tmp/jx
mv /tmp/jx/jx-release-version /usr/local/bin/jx-release-version
chmod a+x /usr/local/bin/jx-release-version

curl -fsSL -o /tmp/helm-docs.tar.gz https://github.com/norwoodj/helm-docs/releases/download/v"${HELM_DOCS_VERSION}"/helm-docs_"${HELM_DOCS_VERSION}"_Linux_x86_64.tar.gz
mkdir -p /tmp/helm-docs && tar -xf /tmp/helm-docs.tar.gz -C /tmp/helm-docs
mv /tmp/helm-docs/helm-docs /usr/local/bin/helm-docs
chmod a+x /usr/local/bin/helm-docs

runuser -u ubuntu renovate

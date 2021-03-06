#!/usr/bin/env sh

set -ex

# add gkh user
adduser -S ci-tools ci-tools

# install apk packages
apk --no-cache add ca-certificates openssl

# install helm
curl --silent --show-error --fail --location --output get_helm.sh https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get
chmod 700 get_helm.sh
./get_helm.sh --version "${HELM_VERSION}"
rm get_helm.sh

# install kind
curl --silent --show-error --fail --location --output /usr/local/bin/kind https://kind.sigs.k8s.io/dl/"${KIND_VERSION}"/kind-linux-amd64
chmod 755 /usr/local/bin/kind

# install kubectl
curl --silent --show-error --fail --location --output /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/"${KUBECTL_VERSION}"/bin/linux/amd64/kubectl
chmod 755 /usr/local/bin/kubectl

# install kubeval
curl --silent --show-error --fail --location --output /tmp/kubeval.tar.gz https://github.com/instrumenta/kubeval/releases/download/"${KUBEVAL_VERSION}"/kubeval-linux-amd64.tar.gz
tar -C /usr/local/bin -xf /tmp/kubeval.tar.gz kubeval
rm /tmp/kubeval.tar.gz

# install sops
curl --silent --show-error --fail --location --output /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/"${SOPS_VERSION}"/sops-"${SOPS_VERSION}".linux
chmod 755 /usr/local/bin/sops

# install terraform
curl --silent --show-error --fail --location --output /tmp/terraform.zip https://releases.hashicorp.com/terraform/"${TERRAFORM_VERSION}"/terraform_"${TERRAFORM_VERSION}"_linux_amd64.zip
unzip /tmp/terraform.zip -d /usr/local/bin
rm /tmp/terraform.zip

# install yq
curl --silent --show-error --fail --location --output /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/"${YQ_BIN_VERSION}"/yq_linux_amd64
chmod 755 /usr/local/bin/yq

# set permissions
mkdir -p /data
chown ci-tools /data /entrypoint.sh /data/commands.sh
chmod +x /entrypoint.sh /data/commands.sh

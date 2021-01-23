# ci-tools

Container image with tools which are useful for ci pipline jobs.

## Contents

* [docker](http://docker.com)
* [gcloud](https://cloud.google.com/sdk/docs/)
* [gnupg](https://pkgs.alpinelinux.org/package/edge/main/x86_64/gnupg)
* [helm](https://www.helm.sh)
* [kind](https://kind.sigs.k8s.io)
* [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/)
* [kubeval](https://github.com/instrumenta/kubeval)
* [SOPS](https://github.com/mozilla/sops)
* [terraform](https://www.terraform.io/)
* [yq](https://github.com/mikefarah/yq)

## Adding changes to this repo

* Create a [fork](https://guides.github.com/activities/forking/)
* Add a [PR](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork)

## Usage

### With GCP Service Account and key file

Passing script with multiple commands

```bash
docker run -v /path/to/your/script.sh:/data/commands.sh:ro bike24/ci-tools
```

Passing script and GCP key-file

```bash
docker run -v /path/to/your/script.sh:/data/commands.sh:ro -v /path/to/your/key-file.json:/data/gcp-key-file.json:ro bike24/ci-tools
```

### Interactive usage with your personal GCP Account

```bash
docker run -it --rm -v /path/to/your/workspace:/data/ bike24/ci-tools bash
# authenticate and paste token
$ gcloud auth application-default login

# setup kubectl context
$ gcloud container clusters get-credentials

# run helm
$ helm install release /data/your/chart -f values.yaml
```

### CI/CD context

Using this image from a CI/CD pipeline is very handy.

You might just want to use the installed binaries like kubectl or helm as commands
but you can also start the container at the beginning of your pipeline.

Afterwards you can pass single commands to running container like:

```bash
CONTAINER_NAME=ci-tools
# Start container
docker run \
  --volume /path/to/your/workdir:/workspace:ro \
  --workdir /workspace
  --volume /path/to/your/gcp-key-file.json:/data/gcp-key-file.json:ro \
  --env GOOGLE_APPLICATION_CREDENTIALS=/data/gcp-key-file.json
  --rm \
  -t \
  --name $CONTAINER_NAME \
  bike24/ci-tools:latest /bin/bash

# Execute arbitrary commands
docker exec $CONTAINER_NAME gcloud auth activate-service-account --key-file=/data/gcp-key-file.json
docker exec $CONTAINER_NAME gcloud config set project my-gcp-project-id
docker exec $CONTAINER_NAME gcloud container clusters get-credentials my-gke-cluster --project my-gcp-project-id --zone my-gke-zone

docker exec $CONTAINER_NAME helm list
docker exec $CONTAINER_NAME gcloud deployment-manager deployments describe my-deployment

# Kill
docker kill $CONTAINER_NAME
```

### Command file examples

Authorize access to GCP with a service account and fetch credentials for running cluster

```bash
gcloud auth activate-service-account --key-file=/data/gcp-key-file.json
gcloud container clusters get-credentials <clusterName> --project <projectId> [--region=<region> | --zone=<zone>]

helm list
kubectl get pods --all-namespaces
```

### Import GPG Keys

To import public GPG keys from keyserver, add them space separated to GPG_PUB_KEYS env variable.

```bash
docker run -e GPG_PUB_KEYS=<key id> bike24/dind-ci-tools:latest
```

## Credits

This repo is inspired by:

* <https://github.com/kiwigrid/gcloud-kubectl-helm>

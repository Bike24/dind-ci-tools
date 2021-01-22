FROM gcr.io/google.com/cloudsdktool/cloud-sdk:324.0.0-alpine

ENV HELM_VERSION v3.5.0
ENV KIND_VERSION v0.9.0
ENV KUBECTL_VERSION v1.20.2
ENV KUBEVAL_VERSION 0.15.0
ENV SOPS_VERSION v3.6.1
ENV TERRAFORM_VERSION 0.14.4
ENV YQ_BIN_VERSION v4.4.1

COPY entrypoint.sh entrypoint.sh
COPY commands.sh /data/commands.sh
COPY install.sh /tmp/install.sh

RUN chmod +x /tmp/install.sh && \
    /tmp/install.sh

VOLUME /data

USER ci-tools

ENTRYPOINT ["/entrypoint.sh"]

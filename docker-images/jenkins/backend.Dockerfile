FROM jenkins/inbound-agent:alpine

LABEL maintainer="Ahmad_Hamade"
LABEL version="latest"

USER root

# Install docker
RUN apk add --update \
  ca-certificates \
  bash \
  docker-cli \
  && rm -rf /var/cache/apk/*

# Install python & aws-cli & gettext(envsubst)
RUN apk add --update \
  shadow \
  python3 \
  py3-pip \
  groff \
  less \
  make \
  curl \
  zip \
  unzip \
  gettext libintl \
  && rm -rf /var/cache/apk/* \
  && pip3 install --upgrade pip setuptools \
  && pip3 --no-cache-dir install --upgrade awscli boto3 \
  && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
  && chmod +x get_helm.sh && ./get_helm.sh

USER jenkins

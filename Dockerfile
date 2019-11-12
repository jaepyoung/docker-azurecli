FROM python:3-alpine

RUN apk update && \
  apk add --no-cache \
  ca-certificates \
  curl \
  openssl \
  tar \
  bash \
  postgresql-client \
  mysql-client \
  grep \
  busybox-extras \
  xz \
  && update-ca-certificates \
  && rm /usr/bin/[[


# Install jq
RUN curl -sL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/local/bin/jq && chmod a+x /usr/local/bin/jq

RUN apk add --virtual=build \
  gcc  \
  libffi-dev \
  musl-dev \
  openssl-dev \
  make 

ARG AZURE_CLI_VERSION=2.0.76

RUN pip --no-cache-dir install azure-cli==${AZURE_CLI_VERSION}



# Install scripts
COPY ./scripts/*.sh /usr/local/bin/
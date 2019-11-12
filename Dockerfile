FROM python:3.7.5-alpine3.10

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


RUN apk update \
  && apk add --no-cache \
  ca-certificates \
  ruby ruby-irb ruby-etc ruby-webrick \
  tini \
  && apk add --no-cache --virtual .build-deps \
  build-base \
  ruby-dev gnupg \
  && echo 'gem: --no-document' >> /etc/gemrc \
  && gem install oj -v 2.18.3 \
  && gem install json -v 2.2.0 \
  && gem install fluentd -v 0.12.43 \
  && gem install bigdecimal -v 1.3.5 \
  && apk del .build-deps \
  && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

RUN addgroup -S fluent && adduser -S -g fluent fluent \
  # for log storage (maybe shared with host)
  && mkdir -p /fluentd/log \
  # configuration/plugins path (default: copied from .)
  && mkdir -p /fluentd/etc /fluentd/plugins \
  && chown -R fluent /fluentd && chgrp -R fluent /fluentd


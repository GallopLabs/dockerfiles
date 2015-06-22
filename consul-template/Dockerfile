FROM ubuntu:14.04
MAINTAINER Jonathon W. Marshall "jonathon@gallop.io"

RUN apt-get update && apt-get install -y wget

ENV CONSUL_TEMPLATE_VERSION "0.10.0"

RUN wget -q https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz \
  && tar -xf consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz && rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz \
  && mv consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64/consul-template /usr/local/bin/

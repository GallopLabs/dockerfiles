FROM ubuntu:14.04
MAINTAINER Jonathon W. Marshall "jonathon@gallop.io"

RUN apt-get update
RUN apt-get install -y --no-install-recommends wget ca-certificates git mercurial bzr && rm -rf /var/lib/apt/lists/*

RUN wget -q https://storage.googleapis.com/golang/go1.4.1.linux-amd64.tar.gz \
  && tar -xf go1.4.1.linux-amd64.tar.gz && rm go1.4.1.linux-amd64.tar.gz \
  && mv go /usr/local && mkdir -p /usr/local/gopath/bin

ENV GOROOT /usr/local/go
ENV GOPATH /usr/local/gopath
ENV PATH   $PATH:$GOROOT/bin:$GOPATH/bin

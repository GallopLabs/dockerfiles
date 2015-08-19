FROM alpine:3.2
MAINTAINER Jonathon W. Marshall "jonathon@gallop.io"

RUN apk --update add nodejs make g++ python curl && rm -rf /var/cache/apk/*

ENV STATSD_VERSION master

RUN mkdir /opt && curl -sSL https://github.com/etsy/statsd/archive/$STATSD_VERSION.tar.gz \
  | tar -v -C /opt -xz && ln -s /opt/statsd-$STATSD_VERSION /opt/statsd

ENV PATH $PATH:/opt/statsd/bin

ADD run.sh /opt/statsd/run.sh

WORKDIR /opt/statsd
RUN npm install

EXPOSE 8125/udp
EXPOSE 8126

CMD ["/opt/statsd/run.sh"]

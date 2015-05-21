FROM galloplabs/nodejs
MAINTAINER Jonathon W. Marshall "jonathon@gallop.io"

RUN apt-get update
RUN apt-get install -y curl

ENV STATSD_VERSION 0.7.2

RUN curl -sSL https://github.com/etsy/statsd/archive/v$STATSD_VERSION.tar.gz \
  | tar -v -C /opt -xz && ln -s /opt/statsd-$STATSD_VERSION /opt/statsd

ENV PATH $PATH:/opt/statsd/bin

ADD run.sh /opt/statsd/run.sh

WORKDIR /opt/statsd
RUN npm install

EXPOSE 8125/udp
EXPOSE 8126

CMD ["./run.sh"]

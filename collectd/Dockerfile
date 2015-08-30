FROM alpine:3.2
MAINTAINER Jonathon W. Marshall "jonathon@gallop.io"

RUN apk --update add python py-pip git collectd collectd-python collectd-network \
  && pip install --upgrade pip \
  && git clone https://github.com/lebauce/docker-collectd-plugin.git /usr/share/collectd/docker-collectd-plugin \
  && cd /usr/share/collectd/docker-collectd-plugin \
  && pip install -r requirements.txt \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/*

COPY run.sh        /run.sh
COPY collectd.conf /etc/collectd/collectd.conf

CMD ["/run.sh"]

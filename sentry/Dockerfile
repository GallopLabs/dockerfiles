FROM galloplabs/python
MAINTAINER Jonathon W. Marshall "jonathon@gallop.io"

RUN apt-get update && apt-get install -y libsasl2-dev libxml2-dev libxslt-dev libpq-dev libldap2-dev libffi-dev

RUN apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user
WORKDIR /home/user

RUN pip install psycopg2 redis hiredis nydus

ENV SENTRY_VERSION 7.7.0
RUN pip install sentry==$SENTRY_VERSION

# install plugins
COPY requirements.txt /home/user/
RUN pip install -r requirements.txt

ADD sentry.conf.py /home/user/.sentry/
RUN chown -R user:user /home/user/.sentry # TODO this might not work on AUFS sometimes
RUN chown -R user:user /var/log/supervisor

USER user
EXPOSE 9000
CMD ["/usr/bin/supervisord"]

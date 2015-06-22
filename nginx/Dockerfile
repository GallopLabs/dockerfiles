FROM galloplabs/consul-template
MAINTAINER Jonathon W. Marshall "jonathon@gallop.io"

RUN apt-get update && apt-get install -y nginx-light
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

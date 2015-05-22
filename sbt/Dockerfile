FROM galloplabs/oracle-jdk
MAINTAINER Jonathon W. Marshall "jonathon@gallop.io"

RUN yum update -y
RUN yum install -y tar
RUN wget -q https://dl.bintray.com/sbt/native-packages/sbt/0.13.8/sbt-0.13.8.tgz \
  && tar -xf sbt-0.13.8.tgz && rm sbt-0.13.8.tgz \
  && mv sbt /usr/local

ENV PATH $PATH:/usr/local/sbt/bin

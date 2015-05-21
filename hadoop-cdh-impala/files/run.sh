#!/usr/bin/env bash

# replace localhost with HADOOP_HOST
if [[ ! -z $HADOOP_HOST ]]; then
  sed -i.bak s,localhost,$HADOOP_HOST,g /etc/hadoop/conf/core-site.xml
  sed -i.bak s,localhost,$HADOOP_HOST,g /etc/hadoop/conf/mapred-site.xml
  sed -i.bak s,localhost,$HADOOP_HOST,g /etc/hadoop/conf/yarn-site.xml
fi

# run command supplied as arguments to this script
$@

#!/usr/bin/env bash

# Fixes perms for mounted volumes
chown -R hdfs:hdfs /var/lib/hadoop-hdfs
chown -R hdfs:hdfs /var/log/hadoop-hdfs
chown -R yarn:yarn /var/log/hadoop-yarn

if ${FORMAT_HDFS}; then
  # format namenode
  su -c "echo 'N' | hdfs namenode -format" hdfs
fi

if ${INITIALIZE_HDFS}; then
  # 1 start hdfs
  su -c "hdfs datanode  2>&1 > /var/log/hadoop-hdfs/hadoop-hdfs-datanode.log" hdfs&
  su -c "hdfs namenode  2>&1 > /var/log/hadoop-hdfs/hadoop-hdfs-namenode.log" hdfs&

  # 2 wait for process starting
  sleep 60

  # 3 exec cloudera hdfs init script
  /usr/lib/hadoop/libexec/init-hdfs.sh

  # 4 init impala hdfs
  su -c "hadoop fs -mkdir /user/impala" hdfs
  su -c "hadoop fs -chown impala:impala /user/impala" hdfs
  su -c "hadoop fs -mkdir /mb_metastore" hdfs
  su -c "hadoop fs -chown impala:impala /mb_metastore" hdfs
  su -c "hadoop fs -mkdir /user/hive/warehouse" hdfs
  su -c "hadoop fs -chown -R hive:impala /user/hive" hdfs
  su -c "hadoop fs -chmod 775 /user/hive/warehouse" hdfs

  # 5 stop hdfs
  killall java
fi

# use hostname for binding interfaces
sed -i.bak s,localhost,$(hostname),g /etc/hadoop/conf/core-site.xml
sed -i.bak s,localhost,$(hostname),g /etc/hadoop/conf/mapred-site.xml
sed -i.bak s,localhost,$(hostname),g /etc/hadoop/conf/yarn-site.xml

# copy hadoop confs
cp -rf /tmp/hadoop_conf/* /etc/hadoop/conf/

# copy impala confs
#cp -f /etc/hadoop/conf/core-site.xml /etc/impala/conf/
#cp -f /etc/hadoop/conf/hdfs-site.xml /etc/impala/conf/

# run supervisord
exec supervisord -c /etc/supervisord.conf



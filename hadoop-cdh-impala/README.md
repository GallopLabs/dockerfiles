# docker-hadoop-cdh-impala

This is a based on [galloplabs/docker-hadoop-cdh-pseudo](https://github.com/gallolabs/docker-hadoop-cdh-pseudo) image.

A basic Cloudera pseudo cluster running HDFS, YARN (with Spark support), and Impala.

This image is intended for development and continuous integration of Hadoop/Spark/Impala workflows, not for critical or production environments.

## Quick Start

Launch a hadoop cluster, setting the hostname for your cluster is important for communication between linked containers.

`docker run -d -P --hostname hadoop --name hadoop galloplabs/hadoop-cdh-impala`

The container takes a few minutes to come up but once it's ready you should be able to connect to HDFS.

`docker run -i -t --rm --link hadoop:hadoop galloplabs/hadoop-cdh-impala hdfs dfs -ls hdfs://hadoop:8020/`

Run mapreduce jobs with YARN. Note that we need use our `run.sh` script which replaces key variables in the hadoop configs based on the `HADOOP_HOST` environment variable.

`docker run -i -t --rm --link hadoop:hadoop -e HADOOP_HOST=hadoop galloplabs/hadoop-cdh-impala /root/run.sh yarn jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 16 100`

Verify the logs of a YARN job. (Your applicationId will be different)

`docker run -i -t --rm --link hadoop:hadoop -e HADOOP_HOST=hadoop galloplabs/hadoop-cdh-impala /root/run.sh yarn logs -applicationId application_1425487566328_0003`

Run Spark jobs with YARN.

`docker run -i -t --link hadoop:hadoop -e HADOOP_HOST=hadoop galloplabs/hadoop-cdh-impala /root/run.sh spark-submit --class org.apache.spark.examples.SparkPi --master yarn-cluster --num-executors 1 --driver-memory 1g --executor-memory 1g --executor-cores 1 /usr/lib/spark/lib/spark-examples*.jar 100`

Run the Impala shell.

`docker run -i -t --rm --link hadoop:hadoop -e HADOOP_HOST=hadoop galloplabs/hadoop-cdh-impala /root/run.sh impala-shell --impalad hadoop`

## Environment Variables

At startup, an init script is launched in the container. It uses global variables defined in `/root/conf.sh` to run the startup procedure. To enable or disable some initialization steps, you can mount a file that defines your own global variables. Here is the list of all defined global variables:

* `FORMAT_HDFS`: Format the HDFS namenode, default value is `true`.
* `INITIALIZE_HDFS`: Run Cloudera's HDFS init script, default value is `true`.
* `HADOOP_HOST`: The hostname of the linked Hadoop server when running commands from container. See: `files/run.sh`.

## Volumes

* `/var/lib/hadoop-hdfs/cache` - HDFS data path. You can prevent formatting of HDFS with `FORMAT_HDFS=false` and `INITIALIZE_HDFS=false` environment variables.
* `/var/log/hadoop-hdfs` - HDFS log path.
* `/var/log/hadoop-yarn` - YARN log path.
* `/tmp/hadoop_conf` - Any files located at this path will be copied to `/etc/hadoop/conf` forcefully on startup, use this to override the default hadoop configs. Note this only happens with the default launch command (see `files/startup.sh`).

## Ports

All hadoop ports are exposed by default.

* *HDFS datanode*
  * `50010` (TCP): dfs.datanode.address (DataNode HTTP server port)
  * `1004` secure (TCP): dfs.datanode.address
  * `50075` (TCP): dfs.datanode.http.address
  * `1006` secure (TCP): dfs.datanode.http.address
  * `50020` (TCP): dfs.datanode.ipc.address
* *HDFS namenode*
  * `8020` (TCP): fs.default.name / fs.defaultFS
  * `50070` (TCP): dfs.http.address / dfs.namenode.http-address
  * `50470` secure (TCP): dfs.https.address / dfs.namenode.https-address
* *YARN resourcemanager*
  * `8032` (TCP): yarn.resourcemanager.address
  * `8030` (TCP): yarn.resourcemanager.scheduler.address
  * `8031` (TCP): yarn.resourcemanager.resource-tracker.address
  * `8033` (TCP): yarn.resourcemanager.admin.address
  * `8088` (TCP): yarn.resourcemanager.webapp.address
* *YARN nodemanager*
  * `8040` (TCP): yarn.nodemanager.localizer.address
  * `8042` (TCP): yarn.nodemanager.webapp.address
  * `8041` (TCP): yarn.nodemanager.address
* *MAPREDUCE historyserver*
  * `10020` (TCP): mapreduce.jobhistory.address
  * `19888` (TCP): mapreduce.jobhistory.webapp.address
* *IMPALA*
  * `21000` (TCP): Impala front end
  * `21050` (TCP): Impala JDBC port
  * `25000` (TCP): Impala web interface
  * `25010` (TCP): Impala state store web interface
  * `25020` (TCP): Impala catalog server web interface

# Oracle license

This container includes an Oracle JDK. By using this container, you accept the Oracle Binary Code License Agreement for Java SE available here: [http://www.oracle.com/technetwork/java/javase/terms/license/index.html](http://www.oracle.com/technetwork/java/javase/terms/license/index.html)

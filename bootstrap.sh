#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# core-site.xml set namenode
#sed -i s/HOSTNAME/$NAMENODE/ /usr/local/hadoop/etc/hadoop/core-site.xml.template
#mv /usr/local/hadoop/etc/hadoop/core-site.xml.template  /usr/local/hadoop/etc/hadoop/core-site.xml
RUN sed s/HOSTNAME/$NAMENODE/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml

# mapred-site.xml set jobhistory
sed -i s/HOSTNAME/$NAMENODE/ /usr/local/hadoop/etc/hadoop/mapred-site.xml

# hdfs-site.xml set secondary
sed -i s/HOSTNAME/$SECONDARY/ /usr/local/hadoop/etc/hadoop/hdfs-site.xml

# yarn-site.xml set ResourceManager
sed -i s/HOSTNAME/$RM/ /usr/local/hadoop/etc/hadoop/yarn-site.xml

# slaves: set node of yarn
echo "$NAMENODE"  > /usr/local/hadoop/etc/hadoop/slaves
echo "$SECONDARY" >> /usr/local/hadoop/etc/hadoop/slaves
echo "$RM" >> /usr/local/hadoop/etc/hadoop/slaves


service sshd start
# $HADOOP_PREFIX/sbin/start-dfs.sh
# $HADOOP_PREFIX/sbin/start-yarn.sh
# $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# core-site.xml 设置namenode
sed s/HOSTNAME/$NAMENODE/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml

# hdfs-site.xml 设置secondary
sed s/HOSTNAME/$SECONDARY/ /usr/local/hadoop/etc/hadoop/hdfs-site.xml

# yarn-site.xml 设置ResourceManager
sed s/HOSTNAME/$RM/ /usr/local/hadoop/etc/hadoop/yarn-site.xml

# slaves yarn的节点
echo "$NAMENODE\n $SECONDARY\n $RM\n" /usr/local/hadoop/etc/hadoop/slaves


service sshd start
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh
$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
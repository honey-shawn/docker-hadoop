#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# core-site.xml set namenode
# mapred-site.xml set jobhistory
# hdfs-site.xml set secondary
# yarn-site.xml set ResourceManager
if [[ $NAMENODE == "" ]]; then
  sed -i s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template
  sed -i s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/mapred-site.xml
  sed -i s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/hdfs-site.xml
  sed -i s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/yarn-site.xml
else
  sed -i s/HOSTNAME/$NAMENODE/ /usr/local/hadoop/etc/hadoop/core-site.xml.template
  sed -i s/HOSTNAME/$NAMENODE/ /usr/local/hadoop/etc/hadoop/mapred-site.xml
  sed -i s/HOSTNAME/$SECONDARY/ /usr/local/hadoop/etc/hadoop/hdfs-site.xml
  sed -i s/HOSTNAME/$RM/ /usr/local/hadoop/etc/hadoop/yarn-site.xml
  # slaves: 设置yarn服务节点
  echo "$NAMENODE"  > /usr/local/hadoop/etc/hadoop/slaves
  echo "$SECONDARY" >> /usr/local/hadoop/etc/hadoop/slaves
  echo "$RM" >> /usr/local/hadoop/etc/hadoop/slaves
fi
mv /usr/local/hadoop/etc/hadoop/core-site.xml.template  /usr/local/hadoop/etc/hadoop/core-site.xml


# start hdfs function
startHDFS(){
    $HADOOP_PREFIX/bin/hdfs namenode -format
    $HADOOP_PREFIX/sbin/start-dfs.sh
    $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver
}

# start services
service sshd start

# 单节点部署时，启动hdfs和yarn
if [[ $NAMENODE == "" ]]; then
    startHDFS
    /usr/local/hadoop/sbin/start-yarn.sh
    echo "hdfs and yarn is starting!"
else
    # 集群上namenode节点，初始化并启动hdfs，yarn需要手动去启动
    if [[ $HOSTNAME == $NAMENODE ]]; then
        startHDFS
    fi
fi


# keep ths container alive
tail -f /dev/null

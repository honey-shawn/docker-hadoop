#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# core-site.xml set namenode
# mapred-site.xml set jobhistory
if [[ $NAMENODE == "" ]]; then
  sed -i s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template
  sed -i s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/mapred-site.xml
else
  sed -i s/HOSTNAME/$NAMENODE/ /usr/local/hadoop/etc/hadoop/core-site.xml.template
  sed -i s/HOSTNAME/$NAMENODE/ /usr/local/hadoop/etc/hadoop/mapred-site.xml
fi
mv /usr/local/hadoop/etc/hadoop/core-site.xml.template  /usr/local/hadoop/etc/hadoop/core-site.xml

# hdfs-site.xml set secondary
if [[ $SECONDARY == "" ]]; then
  sed -i s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/hdfs-site.xml
else
  sed -i s/HOSTNAME/$SECONDARY/ /usr/local/hadoop/etc/hadoop/hdfs-site.xml
fi

# yarn-site.xml set ResourceManager
if [[ $RM == "" ]]; then
  sed -i s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/yarn-site.xml
else
  sed -i s/HOSTNAME/$RM/ /usr/local/hadoop/etc/hadoop/yarn-site.xml
fi

# slaves: set node of yarn
if [[ $RM != "" ]]; then
  echo "$NAMENODE"  > /usr/local/hadoop/etc/hadoop/slaves
  echo "$SECONDARY" >> /usr/local/hadoop/etc/hadoop/slaves
  echo "$RM" >> /usr/local/hadoop/etc/hadoop/slaves
fi

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
    # 集群且指定namenode时，启动hdfs，yarn需要手动去启动
    if [[ $IS_NAMENODE == "yes" ]]; then
        startHDFS
        echo "hdfs is starting!"
        echo "yarn需要手动启动！（例如：docker-compose exec resource-manager /usr/local/hadoop/sbin/start-yarn.sh）"
    fi
fi


# keep ths container alive
tail -f /dev/null
# while true; do sleep 1000; done

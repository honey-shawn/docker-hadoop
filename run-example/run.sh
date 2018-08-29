#!/bin/bash
# 启动docker-compose脚本

#启动容器
docker-compose up -d
docker-compose ps

# 启动hadoop集群、jobhistory以及yarn
docker-compose exec namenode /usr/local/hadoop/bin/hdfs namenode -format

docker-compose exec namenode /usr/local/hadoop/sbin/start-dfs.sh
docker-compose exec namenode /usr/local/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver
docker-compose exec resource-manager /usr/local/hadoop/sbin/start-yarn.sh


# 查看各个容器hadoop集群状态
echo "-----namenode-----"
docker-compose exec namenode jps
echo "-----resource-manager-----"
docker-compose exec resource-manager jps
echo "-----secondary-----"
docker-compose exec secondary jps


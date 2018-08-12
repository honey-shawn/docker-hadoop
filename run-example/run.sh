#!/bin/bash
# 启动docker-compose脚本

#启动容器
docker-compose up -d
docker-compose ps

# 启动hadoop集群和yarn
docker-compose exec namenode /usr/local/hadoop/sbin/start-dfs.sh
docker-compose exec resource-manager /usr/local/hadoop/sbin/start-yarn.sh

# 查看各个容器hadoop集群状态
echo "-----namenode-----"
docker-compose exec namenode jps
echo "-----resource-manager-----"
docker-compose exec resource-manager jps
echo "-----secondary-----"
docker-compose exec secondary jps


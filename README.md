# honeyshawn/hadoop:2.7.6镜像
使用docker完成hadoop完全分布式搭建

# 组件版本
* hadoop2.7.6
* JDK1.8


# 构建hadoop镜像

```
docker build  -t honeyshawn/hadoop:2.7.6 .
```
# 拉取hadoop镜像

```
docker pull honeyshawn/hadoop:2.7.6
```

# 使用hadoop镜像构建Hadoop集群

**需要配置的参数**
```sbtshell
# namenode所在容器的容器名
NAMENODE=namenode
# secondaryNamenode所在容器的容器名
SECONDARY=secondary
# ResourceManager所在容器的容器名
RM=resource-manager
```

参考run-example文件夹的使用

**案例集群部署规划：**

|	|namenode|	resource-manager|	secondary|
| ------------- |:-------------:| -----:|-----:|
|HDFS|NameNode/DataNode|DataNode|SecondaryNameNode/DataNode|
|YARN|NodeManager|ResourceManager/NodeManager|NodeManager|

**启动hadoop集群和yarn**
```shell
docker-compose exec namenode /usr/local/hadoop/sbin/start-dfs.sh
docker-compose exec resource-manager /usr/local/hadoop/sbin/start-yarn.sh
```
**案例启动**
```shell
sh run.sh
```


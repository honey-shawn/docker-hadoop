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

# 使用honeyshawn/hadoop镜像构建Hadoop集群
注意：单节点部署不需要配置以下参数。

**搭建Hadoop集群需要配置的参数**

* NAMENODE，namenode所在容器的容器名
* SECONDARY，secondaryNamenode所在容器的容器名
* RM，ResourceManager所在容器的容器名

注意：docker-compose需要配置hostname，且与容器名一致，方可将hdfs集群运行起来，反之则需要手动进入容器启动服务：
```$xslt
  docker-compose exec namenode /usr/local/hadoop/bin/hdfs namenode -format
  docker-compose exec namenode /usr/local/hadoop/sbin/start-dfs.sh
  docker-compose exec namenode /usr/local/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver
```

# hadoop完全分布式集群案例使用（run-example文件夹）

###1.案例集群部署规划：

|	|namenode|	resource-manager|	secondary|
| ------------- |:-------------:| -----:|-----:|
|HDFS|NameNode/DataNode|DataNode|SecondaryNameNode/DataNode|
|YARN|NodeManager|ResourceManager/NodeManager|NodeManager|

###2.案例启动
#####a.容器准备
```shell
sh run.sh
```
#####b.启动hadoop集群和yarn
 ```shell
  docker-compose exec resource-manager /usr/local/hadoop/sbin/start-yarn.sh
 ```

###3.状态查看
```$xslt
echo "-----namenode-----"
docker-compose exec namenode jps
echo "-----resource-manager-----"
docker-compose exec resource-manager jps
echo "-----secondary-----"
docker-compose exec secondary jps
```
# hadoop单节点使用
docker-compose.yml参考：
```yml
version: '2'
services:
  hadoop:
    image: honeyshawn/hadoop:2.7.6
    container_name: hadoop
    hostname: hadoop
    ports:
        - "50070:50070"  # namenode url
        - "49707:49707"
        - "19888:19888"  # jobhistory url
        - "10020:10020"  # jobhistory
        - "9000:9000"    # namenode
        - "8088:8088"  # yarn url
        - "50090:50090"  # SecondaryNameNode url
```
启动命令：
```$xslt
docker-compose up -d
```
状态查看：
```$xslt
docker-compose exec hadoop jps
```


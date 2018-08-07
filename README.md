# Hadoop2.7.1 Docker image
使用docker完成hadoop完全分布式搭建

# Build the image

If you'd like to try directly from the Dockerfile you can build the image as:

```
docker build  -t honeyshawn/hadoop:2.7.1 .
```
# Pull the image

The image is also released as an official Docker image from Docker's automated build repository - you can always pull or refer the image when launching containers.

```
docker pull honeyshawn/hadoop:2.7.1
```

# Start a container

In order to use the Docker image you have just build or pulled use:

**Make sure that SELinux is disabled on the host. If you are using boot2docker you don't need to do anything.**

```
docker run -it honeyshawn/hadoop:2.7.1 /etc/bootstrap.sh -bash
```

FROM alpine:latest

# just for boot scripts
RUN apk update && apk add bash

RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
RUN mkdir -p /netapp /etc/netappdvp

# need to be able to drop our .sock in /run/docker/plugins
RUN ln -s /host/run/docker /run/docker

# docker now expects the spec file in /etc/docker/plugins
RUN mkdir -p /etc/docker
RUN mkdir -p /host/etc/docker/plugins
RUN ln -s /host/etc/docker/plugins /etc/docker/plugins

RUN mkdir -p /host/var/log
RUN rmdir /var/log
RUN ln -s /host/var/log /var/log

RUN mkdir -p /host/var/lib/docker-volumes
RUN ln -s /host/var/lib/docker-volumes /var/lib/docker-volumes

ADD netappdvp /netapp
ADD boot.sh /netapp

#ENTRYPOINT ["/netapp/netappdvp", "--in-container=true"]
ENTRYPOINT ["/netapp/boot.sh", "--", "--in-container=true"]
WORKDIR /etc/netappdvp


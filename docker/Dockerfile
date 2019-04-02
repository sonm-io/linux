FROM ubuntu:bionic
RUN sed -e s/archive.ubuntu.com/mirror.yandex.ru/ -i /etc/apt/sources.list
RUN apt update -q
RUN apt install build-essential bison bc libncurses-dev kmod cpio flex devscripts libssl-dev -y

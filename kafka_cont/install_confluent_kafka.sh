#!/bin/bash

install_sudo() {
  echo "********************"
  echo "install sudo"
  echo "********************"

  #라이브러리 설치
  apt-get update -y
  apt-get upgrade -y
  apt-get install -y sudo

#  sudo adduser kafka -m
#  sudo usermod -aG sudo kafka  #make the user sudo
#  sudo su kafka  #Login as kafka user
}

install_base() {
  echo "********************"
  echo "install base"
  echo "********************"

  sudo apt-get update && sudo apt-get upgrade -y
  sudo apt-get install -y curl \
      default-jre \
      build-essential \
      libssl-dev \
      wget

  # update-alternatives --config java 로 java 위치 확인 가능
  export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
  java -version
}

install_kafka() {
  scala_verion=2.13
  kafka_version=2.7.0
  wget https://www.apache.org/dist/kafka/$kafka_version/kafka_$scala_verion-$kafka_version.tgz -O /home/kafka/kafka.tgz

  mkdir /opt/kafka
  tar -xzvf kafka.tgz -C /opt/kafka

  export KAFKA_HOME=/opt/kafka/kafka_$scala_verion-$kafka_version
  export PATH="$PATH:${KAFKA_HOME}/bin"

  #  링크 기호 생성
  ln -s /opt/kafka/kafka_2.12-2.3.1/config/server.properties /etc/kafka.properties

  # 카프카 실행
#  kafka-server-start.sh /etc/kafka.properties

}

install_sudo
install_base
install_kafka
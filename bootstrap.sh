#!/bin/bash

echo '172.17.64.0	master' >> /etc/hosts
echo '172.17.64.1	slave1' >> /etc/hosts
echo '172.17.64.2	slave2' >> /etc/hosts
echo '172.17.64.3	slave3' >> /etc/hosts
echo '172.17.128.0	slave4' >> /etc/hosts
echo '172.17.128.1	slave5' >> /etc/hosts
echo '172.17.128.2	slave6' >> /etc/hosts
echo '172.17.128.3	slave7' >> /etc/hosts

: ${HADOOP_PREFIX:=/usr/local/hadoop}

echo 'slave1' >  $HADOOP_PREFIX/etc/hadoop/slaves
echo 'slave2' >> $HADOOP_PREFIX/etc/hadoop/slaves
echo 'slave3' >> $HADOOP_PREFIX/etc/hadoop/slaves
echo 'slave4' >> $HADOOP_PREFIX/etc/hadoop/slaves
echo 'slave5' >> $HADOOP_PREFIX/etc/hadoop/slaves
echo 'slave6' >> $HADOOP_PREFIX/etc/hadoop/slaves
echo 'slave7' >> $HADOOP_PREFIX/etc/hadoop/slaves


$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
# sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml
sed s/HOSTNAME/master/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml

service sshd start
# $HADOOP_PREFIX/sbin/start-dfs.sh
# $HADOOP_PREFIX/sbin/start-yarn.sh

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

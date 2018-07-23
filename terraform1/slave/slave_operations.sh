#!/bin/bash
curl -fsSL get.docker.com -o get-docker.sh
chmod 755 get-docker.sh
bash ./get-docker.sh
echo DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4 -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock" > /etc/default/docker
sudo service docker start
sudo usermod -aG docker ubuntu
#sudo docker swarm init
sudo apt-get install git -y
#docker pull variable_value
image=java

if [ $image == java ]
then
sudo docker pull jenkinsimage/jenkins_slave
sudo docker tag jenkinsimage/jenkins_slave jenkins_slave
elif [ $image == android  ]
then
sudo docker pull aabhassinha/android
elif [ $image == "java android"]
then
sudo docker pull jenkinsimage/jenkins_slave
sudo docker pull aabhassinha/android
sudo docker tag jenkinsimage/jenkins_slave jenkins_slave
fi

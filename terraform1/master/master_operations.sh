#!/bin/bash
curl -fsSL get.docker.com -o get-docker.sh
chmod 755 get-docker.sh
bash ./get-docker.sh
sudo service docker start
sudo usermod -aG docker ubuntu
#sudo docker swarm init
sudo apt-get install git make -y
#git clone https://github.com/anuj810/jenkins.git
git clone https://github.com/anuj810/automated-jenkins.git
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
cd automated-jenkins
image=test
slave=0
ip=null

if [ $slave -eq 1 ]
then
sed -i s"/proxy1/$ip/" jenkins-master/docker_cloud_config
fi


if [ $image == "java" ]
then
sed -i s'/docker_slave_template_config/docker_java_slave_config/' jenkins-master/change.sh
sed -i s'/docker_slave_template_config/docker_java_slave_config/g' jenkins-master/Dockerfile


elif [ $image == "android" ]
then
sed -i s"/slave_image/android/" makefile
if [ $slave -eq 0 ]
then
sudo make pull
fi
sed -i s'/docker_slave_template_config/docker_android_slave_config/' jenkins-master/change.sh
sed -i s'/docker_slave_template_config/docker_android_slave_config/g' jenkins-master/Dockerfile


elif [ $image == "android java"  ]
then
sed -i s"/slave_image/android/" makefile
if [ $slave -eq 0 ]
then
sudo make pull
fi
sed -i s'/docker_slave_template_config/docker_mutiple_slave_template/' jenkins-master/change.sh
sed -i s'/docker_slave_template_config/docker_multiple_slave_template/g' jenkins-master/Dockerfile

fi

sudo make build
sudo make run
sleep 120
sudo docker exec -it jenkins_master_1 bash -c "cd /var/jenkins_home; bash change.sh"
sudo docker restart jenkins_master_1


#!/bin/bash

cluster_count=2 
image=java

wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform_0.11.7_linux_amd64.zip
sudo cp terraform /usr/local/bin/

if [ $cluster_count == 1 ]
then
cd terraform1
cd master
if [ $image == java ]
then
sed -i s'/image=test/image=java/' master_operations.sh


elif [ $image == android ]
then
sed -i s'/image=test/image=android/' master_operations.sh


else
sed -i s'/image=test/image=java android' master_operations.sh


fi

terraform init
terraform apply -var 'ami_id="'"${id}"'"' -auto-approve 
fi

if [ $cluster_count == 2 ]
then

cd terraform1
cd slave
echo "Building Slave Node"
if [ $image == java ]
then
sed -i s'/image=test/image=java/' slave_operations.sh
elif [ $image == android ]
then
sed -i s'/image=test/image=android/' slave_operations.sh
else
sed -i s'/image=test/image=java android/' slave_operations.sh
fi

terraform init
terraform apply -var 'ami_id="'"${id}"'"' -auto-approve > slave.log
ip=$(cat slave.log  | tail -1 | cut -d "=" -f2 | cut -d " " -f2 | awk {'print $1'})

echo "Slave Node IP is $ip"

echo "Building Master Node"
cd ../master
sed -i s'/slave=0/slave=1/' master_operations.sh
sed -i s"/ip=null/ip=$ip/" master_operations.sh

terraform init
terraform apply -var 'ami_id="'"${id}"'"' -auto-approve
fi


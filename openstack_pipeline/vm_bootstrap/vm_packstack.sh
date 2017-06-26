#!/bin/bash
## ENV Variable Dependencies
URL_TO_PROJECT=https://github.com/pivotal-gss/openstack-for-pcf.git
URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz
URL_TO_EPEL=http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
export GOVC_URL="https://$USERNAME:$PASSWORD@vcsa-01.haas-59.pez.pivotal.io/sdk"
export GOVC_DATACENTER=Datacenter
export GOVC_INSECURE=true

## Update and install Dependencies
rpm -iUvh $URL_TO_EPEL;

    yum update -y && yum install ansible git wget -y;
    wget $URL_TO_BINARY;

gzip -d govc_linux_amd64.gz;
mv govc_linux_amd64 /usr/bin/govc;
chmod +x /usr/bin/govc

## Checking VM status
git clone https://github.com/pivotal-gss/openstack-for-pcf.git -b dev_branch

sh openstack-for-pcf/deploy_packstack_ping.sh -h CONTROLLER -n 10.193.93.3
sh openstack-for-pcf/deploy_packstack_ping.sh -h COMPUTE -n 10.193.93.4

## Test vSphere Connection | VM availability
if ! [[ $(govc about.cert | awk -F: '{print $1}' | grep "vcsa-01.haas-59.pez.pivotal.io") ]] ;
   then echo "Connection to vSphere.. Success!" ;
       else exit 1
fi

## Install remote SSH key
mkdir -m0700 ~/.ssh
cp git-resources/id_rsa* ~/.ssh/

ls -al
chmod 0600 /root/.ssh/id_rsa*

## Setup Ansible ENV
export ANSIBLE_HOST_KEY_CHECKING=False

cat <<EOF >>hosts
[openstack-controller]
10.193.93.3

[openstack-compute]
10.193.93.4
EOF

\cp hosts /etc/ansible/

## Test Ansible Config
if [[ $(ansible all -m ping | awk -F: '{print $1}' | grep "SUCCESS") ]];
   then echo "Ansible is Ready!";
       else echo "Do Not Deploy, Ansible is not Ready!"
            exit 1
fi

## Run Base PlayBooks
ansible-playbook deploy_packstack_compute.yml
ansible-playbook deploy_packstack_controller.yml

## Reboot VM's and Run Final PlayBook
echo "Sleep for 1 minute, rebooting VM's"
govc vm.power -reset=true gss-lab-28-controller
govc vm.power -reset=true gss-lab-28-compute
sleep 1m

ansible-playbook deploy_packstack_final.yml

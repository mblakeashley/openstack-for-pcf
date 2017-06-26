#!/bin/bash
## BootStrap dependices for OpenStack VM Infrastucture
URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz
URL_TO_EPEL=http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
CONTROLLER=10.193.93.3
COMPUTE=10.193.93.4

## Update and install Dependencies
rpm -iUvh $URL_TO_EPEL;
yum update -y && yum install ansible git wget openssh-server openssh-clients -y;
wget $URL_TO_BINARY;
gzip -d govc_linux_amd64.gz;
mv govc_linux_amd64 /usr/bin/govc;
chmod +x /usr/bin/govc

## Test govc login
# Export govc Variables
export GOVC_URL="https://$USERNAME:$PASSWORD@vcsa-01.haas-59.pez.pivotal.io/sdk"
export GOVC_DATACENTER=Datacenter
export GOVC_INSECURE=true

if ! [[ $(govc about.cert | awk -F: '{print $1}' | grep "vcsa-01.haas-59.pez.pivotal.io") ]] ;
   then echo "Connection to vSphere.. Success!"
 else exit 1
fi

## Create Base VM's for OpenStack IaaS
#govc vm.create -on=false -pool=RP28 -ds=/Datacenter/datastore/LUN01 -c=16 -m=90000 -disk=700GB -net.address=00:50:56:ac:e5:83 -net=env28 gss-lab-28-controller
#govc vm.create -on=false -pool=RP28 -ds=/Datacenter/datastore/LUN01 -c=16 -m=90000 -disk=700GB -net.address=00:50:56:ac:e5:14 -net=env28 gss-lab-28-compute
#govc vm.change -vm=gss-lab-28-controller -nested-hv-enabled=true
#govc vm.change -vm=gss-lab-28-compute -nested-hv-enabled=true
#govc vm.power -on=true gss-lab-28-controller
#govc vm.power -on=true gss-lab-28-compute

## Allow Base OS to Install
echo "Sleep During CentOS installation."
#sleep 6m

## Restart VM's after install
echo "Sleep for 1 minute, rebooting VM's"
#govc vm.power -reset=true gss-lab-28-controller
#govc vm.power -reset=true gss-lab-28-compute
#sleep 1m

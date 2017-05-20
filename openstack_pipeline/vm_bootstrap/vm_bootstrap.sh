#!/bin/bash -x
##Dependencies for task "openstack_vm_bootstrap"
URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz


## Update and install Dependencies
if [[ $(yum list installed | grep "wget") == '' ]] ;
   then yum update && yum install wget -y;
        wget $URL_TO_BINARY;
        mv govc_linux_amd64 /usr/bin/govc;
        chmod +x /usr/bin/govc

   else wget $URL_TO_BINARY;
        gzip -d govc_linux_amd64.gz;
        mv govc_linux_amd64 /usr/bin/govc;
        chmod +x /usr/bin/govc
fi


## Test govc login
# Export govc Variables
export GOVC_URL="https://$USERNAME:$PASSWORD@vcsa-01.haas-59.pez.pivotal.io/sdk"
export GOVC_DATACENTER=Datacenter
export GOVC_INSECURE=true

if [[ $(govc about.cert | grep "vcsa-01.haas-59.pez.pivotal.io") == '' ]] ;
   then "Connection to vSphere.. Success!"
 else exit 1
fi


## Create Base VM's for OpenStack IaaS
govc vm.create  -pool=RP28 -ds=/Datacenter/datastore/LUN01 -c=16 -m=90000 -disk=700GB -net.address=00:50:56:ac:e5:83 -net=env28 gss-lab-28-controller
govc vm.create  -pool=RP28 -ds=/Datacenter/datastore/LUN01 -c=16 -m=90000 -disk=700GB -net.address=00:50:56:ac:e5:14 -net=env28 gss-lab-28-compute
govc vm.change -vm=gss-lab-28-controller -nested-hv-enabled=true
govc vm.change -vm=gss-lab-28-compute -nested-hv-enabled=true

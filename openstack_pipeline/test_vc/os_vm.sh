#!/bin/bash -x
##Dependencies for task "openstack_vm_bootstrap"
URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz


## Update and install Dependencies
if [[ $(yum list installed | grep "wget") == '' ]] ;
   then yum update && yum install wget -y
else wget $URL_TO_BINARY;
     gzip -d govc_linux_amd64.gz;
     mv govc_linux_amd64 /usr/local/bin/govc;
     chmod +x /usr/local/bin/govc
fi


## Test govc login
# Export govc Variables
export GOVC_URL="https://$USERNAME:$PASSWORD@vcsa-01.haas-59.pez.pivotal.io/sdk"
export GOVC_DATACENTER=Datacenter
export GOVC_INSECURE=true

if [[ $govc about.cert | grep "vcsa-01.haas-59.pez.pivotal.io") == '' ]] ;
   then exit 1
  else echo "Connection to vSphere.. Success!"
fi


## Create Base VM's for OpenStack IaaS

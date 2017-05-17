#!/bin/sh
#Dependencies for task "openstack_vm_bootstrap"

# Script Variables
URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz
GIT_REPO=https://github.com/vmware/govmomi.git

# Update and install Dependencies
apt-get update && apt-get install wget -y
wget $URL_TO_BINARY
gzip -d govc_linux_amd64.gz | cp govc_linux_amd64 /usr/local/bin/govc
chmod +x /usr/local/bin/govc

# Set SSH Keys
#\cp  ../../id_rsa.pub ~/.ssh/

#Test govc login
. source_vc
govc datacenter.info


# Create Base VM's for OpenStack IaaS
#govc vm.create  -annotation=gss-lab-29-os-controller -pool=RP28 -c=16 -m=91024 -net=env28

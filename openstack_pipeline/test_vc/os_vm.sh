#!/bin/sh
#Dependencies for task "openstack_vm_bootstrap"
set -x

# Script Variables
URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz


# Set SSH Keys
#\cp  ../../id_rsa.pub ~/.ssh/

#Test govc login
export GOVC_URL='https://$username:$password@vcsa-01.haas-59.pez.pivotal.io/sdk'
export GOVC_DATACENTER=Datacenter
export GOVC_INSECURE=true

govc datacenter.info


# Create Base VM's for OpenStack IaaS
#govc vm.create  -annotation=gss-lab-29-os-controller -pool=RP28 -c=16 -m=91024 -net=env28

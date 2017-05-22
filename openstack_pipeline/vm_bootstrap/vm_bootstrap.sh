#!/bin/bash -x
##Dependencies for task "openstack_vm_bootstrap"
URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz
URL_TO_PROJECT=https://github.com/pivotal-gss/openstack-for-pcf.git
CONTROLLER=10.193.93.3
COMPUTE=10.193.93.4

## Update and install Dependencies
if [[ $(yum list installed | grep "wget") == '' ]] ;
   then yum update && yum install git wget -y;
        wget $URL_TO_BINARY;
        gzip -d govc_linux_amd64.gz;
        mv govc_linux_amd64 /usr/bin/govc;
        chmod +x /usr/bin/govc

   else wget $URL_TO_BINARY;
        gzip -d govc_linux_amd64.gz;
        mv govc_linux_amd64 /usr/bin/govc;
        chmod +x /usr/bin/govc
fi

# Install our SSH key
mkdir -m0700 /root/.ssh/

cat <<EOF >/root/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdvWYj3IDSiirnXUlnBcV/jy7G5Jhwz7HlNYpVa2l/opF+wmucHdg4asIWCxM1LDfZNCxyGnL7YcAazPOheY6b9X2PsQDrX3glrWJQ4IYO1cBjOldV0MujnxMSo3ylemP3Ib126HxMflMYKyPj47p+AuR1hJ2AKHlyW2XWNjHpGX63pEBZ4sEYIt1VHJYlnV1dJTrk+4eDB1b8mFqz8NFay3OyfbtkbvS+kUW7kQYaustOJw2c2FEoF2kSxXt97oHP25jHWzrQVCGmwWKP92GiBcrC/KFhVb4A02MwA7vmT1poo/iizRELpuuYR8d8xU7rNmidx2elBMF+017Zs7Rr test_ops@example.com
EOF

### Set Permissions
chmod 0600 /root/.ssh/*
restorecon -R /root/.ssh/

## Test govc login
# Export govc Variables
export GOVC_URL="https://$USERNAME:$PASSWORD@vcsa-01.haas-59.pez.pivotal.io/sdk"
export GOVC_DATACENTER=Datacenter
export GOVC_INSECURE=true

if ! [[ $(govc about.cert | awk -F: '{print $1}' | grep "vcsa-01.haas-59.pez.pivotal.io")  ]] ;
   then "Connection to vSphere.. Success!"
 else exit 1
fi

## Create Base VM's for OpenStack IaaS
govc vm.create -on=false -pool=RP28 -ds=/Datacenter/datastore/LUN01 -c=16 -m=90000 -disk=700GB -net.address=00:50:56:ac:e5:83 -net=env28 gss-lab-28-controller
govc vm.create -on=false -pool=RP28 -ds=/Datacenter/datastore/LUN01 -c=16 -m=90000 -disk=700GB -net.address=00:50:56:ac:e5:14 -net=env28 gss-lab-28-compute
govc vm.change -vm=gss-lab-28-controller -nested-hv-enabled=true
govc vm.change -vm=gss-lab-28-compute -nested-hv-enabled=true
govc vm.power -on=true gss-lab-28-controller
govc vm.power -on=true gss-lab-28-compute

# Waiting for VM's to spawn
while :; do
  if ! ping -c 1 $CONTROLLER
       then
           echo "Wating on Controller, sleep for 2 minutes";
           sleep 2m
then
     echo "Controller is ready!";
     exit 0
fi
done

while :; do
  if ! ping -c 1 $COMPUTE
       then
           echo "Wating on Compute, sleep for 2 minutes";
           sleep 2m
then
     echo "Compute is ready!";
     exit 0
fi
done

# Clone openstack-for-pcf Repo and run scripts
git clone $URL_TO_PROJECT dev_branch
cd openstack-for-pcf

local RESULTS
RESULTS=$(ssh root@$CONTROLLER install_packages.sh)
echo $?

local RESULTS
RESULTS=$(ssh root@$CONTROLLER provision_packstack.sh)
echo $?

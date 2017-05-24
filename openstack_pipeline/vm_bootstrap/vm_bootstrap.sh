#!/bin/bash -x
##BootStrap dependices for OpenStack VM Infrastucture
URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz
URL_TO_EPEL=http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
CONTROLLER=10.193.93.3
COMPUTE=10.193.93.4

## Update and install Dependencies
rpm -iUvh $URL_TO_EPEL;
yum update && yum install ansible git wget openssh-server openssh-clients -y;
wget $URL_TO_BINARY;
gzip -d govc_linux_amd64.gz;
mv govc_linux_amd64 /usr/bin/govc;
chmod +x /usr/bin/govc

# Install our SSH key
ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
cat <<EOF >/tmp/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArMEQm0pG52rzaggxyfhPwtTlD2KnlZVp/KmTelUNbBdAjuiE3ee1nGq487+yyajBssA7ubOngSJyjdWc7bT8D5SJqyaGdR2VVDnJ1a9R3hh6Cu8NTbkS9NTmLXWXlAYM0J8pA/oXGxV4djYfzkXCbBdRvLa/zTfjAKOhOzpTzR6ecvZjBpVLHzPIuJdii0/Hlq6LAqtH/90Ru63omMaTflHFpVDGfnnryQtJnSUi+QtRwhJFk/A1Sp0aLz3xe0MHpXeyzgP5t9pQOU5lvEh/aXuxqo2HH0Jys/MOCaIGDR3HHeOuzQxdwbbl1hJWlcNuVKOY4JIxqyCW4BPIz4EXfQ== root@localhost.localdomain
EOF

\cp /tmp/id_rsa.pub /root/.ssh/id_rsa.pub
chmod 0600 /root/.ssh/id_rsa.pub
ls -lart /root/.ssh/
cat /root/.ssh/id_rsa.pub

# Make ansible hosts file, copy and test connection
export ANSIBLE_HOST_KEY_CHECKING=False

cat <<EOF >>hosts
[openstack]
10.193.93.3
EOF


\cp hosts /etc/ansible/

if ! [[ $(ansible all -m ping | awk -F: '{print $1}' | grep "SUCCESS") ]];
   then echo "Ansible is Ready!"
else exit 1
fi

## Test govc login
# Export govc Variables
export GOVC_URL="https://$USERNAME:$PASSWORD@vcsa-01.haas-59.pez.pivotal.io/sdk"
export GOVC_DATACENTER=Datacenter
export GOVC_INSECURE=true

if ! [[ $(govc about.cert | awk -F: '{print $1}' | grep "vcsa-01.haas-59.pez.pivotal.io") ]] ;
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

## Allow Base OS to Install
echo "Sleeping until CentOS is installed.."
sleep 6 minutes

## Rebooting VM's after Updates
govc vm.power -reset=true gss-lab-28-controller
govc vm.power -reset=true gss-lab-28-compute

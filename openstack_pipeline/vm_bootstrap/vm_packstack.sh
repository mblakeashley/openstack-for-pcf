#!/bin/bash -x
## Checks and Ansible Deployment to VM Infrastucture
URL_TO_PROJECT=https://github.com/pivotal-gss/openstack-for-pcf.git
URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz
URL_TO_EPEL=http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

## Update and install Dependencies
rpm -iUvh $URL_TO_EPEL;
yum update && yum install ansible git wget -y;
wget $URL_TO_BINARY;
gzip -d govc_linux_amd64.gz;
mv govc_linux_amd64 /usr/bin/govc;
chmod +x /usr/bin/govc

# Clone openstack-for-pcf Repo and run scripts
git clone $URL_TO_PROJECT -b dev_branch
cd openstack-for-pcf

# Waiting for VM's to spawn
sh deploy_ping.sh -n 10.193.93.3 -h Controller
sh deploy_ping.sh -n 10.193.93.4 -h Compute

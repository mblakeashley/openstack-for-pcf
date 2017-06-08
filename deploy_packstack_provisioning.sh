#!/bin/sh
# This script is intended to provision system settings to support OpenStack deployments
source /opt/openstack-for-pcf/deploy_functions.sh
OS_FLAVOR="Mitaka"
OS_REPO="https://repos.fedorapeople.org/repos/openstack/openstack-mitaka/rdo-release-mitaka-6.noarch.rpm"
CONTROLLER=10.193.93.2
COMPUTE=10.193.93.3

# Provisioning OpenStack Requirements
step "+ Configure Firewall and Network"
try silent sudo systemctl disable firewalld
try silent sudo systemctl stop firewalld
try silent sudo systemctl disable NetworkManager
try silent sudo systemctl stop NetworkManager
try silent sudo systemctl enable network
try silent spinner sudo systemctl start network
next

step "+ Checking SELinux Settings"
next
if ! [[  $(cat /etc/default/grub | awk -F: '{print $1}' | grep "0") ]]  ;
     then step "+ Setting SELinux to permissive"
          try silent spinner sed -i "s/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/g" /etc/default/grub ;
     else step "+ SELinux settings are correct"
fi
next

step "+ Adding OpenStack Repo - $OS_FLAVOR"
	  try silent yum install -y $OS_REPO
next

step "+ Installing Packstack"
	  try silent yum install -y openstack-packstack
next

#!/bin/sh
# This script is intened to install all dependencies pertaining to the openstack-for-pcf project
set -e
source ./ops_functions.sh


### Update and Install Dependencies
step "+ Running YUM Update" 
	 try silent yum update -y -q -e 0

step "+ Installing Base Packages"
	 try silent yum install -y -q -e 0 vim net-tools tigervnc-server xorg-x11-fonts-Type1

step "+ Installing GNOME Desktop.. This will take some time"
	 try silent yum groupinstall "GNOME Desktop"  -y -q -e 0



### Install OpenStack YUM Repo and Packstack
step "+ Adding OpenStack Repo - Mitaka"
	 try silent yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-mitaka/rdo-release-mitaka-6.noarch.rpm 

step "+ Installing Packstack"
	 try silent yum install -y openstack-packstack
#!/bin/sh
# This script is intened to install all dependencies pertaining to the openstack-for-pcf project

OS_REPO="https://repos.fedorapeople.org/repos/openstack/openstack-mitaka/rdo-release-mitaka-6.noarch.rpm"
source ./ops_functions.sh


### Update and Install Dependencies
step "+ Running YUM Update" 
	 try silent yum update -y -q -e 0
next


step "+ Installing Base Packages"
	 try silent yum install -y -q -e 0 vim net-tools tigervnc-server xorg-x11-fonts-Type1
next


step "+ Installing GNOME Desktop.. This will take some time"
	 try silent yum groupinstall "GNOME Desktop"  -y -q -e 0
next


### Install OpenStack YUM Repo and Packstack
step "+ Adding OpenStack Repo - Mitaka"
	 try silent yum install -y $OS_REPO 
next


step "+ Installing Packstack"
	 try silent yum install -y openstack-packstack
next

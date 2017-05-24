#!/bin/sh
# This script is intened to install all dependencies pertaining to the openstack-for-pcf project
OS_FLAVOR="Mitaka"
OS_REPO="https://repos.fedorapeople.org/repos/openstack/openstack-mitaka/rdo-release-mitaka-6.noarch.rpm"
source /opt/openstack-for-pcf/deploy_functions.sh


### Update and Install Dependencies
step "+ Adding Repos"
    try silent rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org;
		           rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

step "+ Running YUM Update"
	 try silent yum update -y -q -e 0
next

step "+ Installing Base Packages"
	 try silent yum --enablerepo=elrepo-kernel install -y -q -e 0 vim net-tools tigervnc-server xorg-x11-fonts-Type1 install kernel-ml
next

step "+ Installing GNOME Desktop.. This will take some time"
	 try silent yum groupinstall "GNOME Desktop" "Graphical Administration Tools"  -y -q -e 0
next

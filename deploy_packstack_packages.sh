#!/bin/sh
# This script is intened to install all dependencies pertaining to the openstack-for-pcf project
source /opt/openstack-for-pcf/deploy_functions.sh

# Update and Install Dependencies
step "+ Adding Repos"
    try silent rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org;
		           rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

step "+ Running YUM Update"
	  try silent yum update -y -q -e 0
next

step "+ Installing Base Packages and Kernel Update Version"
	  try silent yum --enablerepo=elrepo-kernel install -y -q -e 0 vim net-tools tigervnc-server install kernel-ml;
              grub2-set-default 0;
              grub2-mkconfig -o /boot/grub2/grub.cfg

next

step "+ Installing KDE Desktop.. This will take some time"
	  try silent yum groupinstall "KDE Plasma Workspaces"  -y -q -e 0;
              systemctl set-default graphical.target;
              systemctl isolate graphical.target
next

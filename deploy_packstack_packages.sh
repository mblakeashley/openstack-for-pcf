#!/bin/sh
# This script is intened to install all dependencies pertaining to the openstack-for-pcf project
source /opt/openstack-for-pcf/deploy_functions.sh
USER=stack


# Setup guest accounts for VNC
step "+ Checking user accounts"
next
if [[ $(cat /etc/passwd | awk -F: '{print $1}' | grep "stack") == '' ]] ;
   then step "+ Created new user *$USER*" ;
                try silent adduser stack ;
                try silent passwd stack;
                echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    else echo "Users are Defined!!"
fi
next

# Update and Install Dependencies
step "+ Adding Repos"
        try silent rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org ;
		    try silent rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
next

step "+ Running YUM Update"
	      try silent yum update -y -q -e 0
next

step "+ Installing Base Packages and Kernel Update Version"
        try silent yum --enablerepo=elrepo-kernel install kernel-ml -y ;
        try silent yum vim net-tools tigervnc-server -y ;
        try silent grub2-set-default 0 ;
        try silent grub2-mkconfig -o /boot/grub2/grub.cfg
next

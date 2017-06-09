#!/bin/sh
# This script is intened to install all dependencies pertaining to the openstack-for-pcf project
source /opt/openstack-for-pcf/deploy_functions.sh
USER=stack


# Setup guest accounts for VNC
step "+ Checking user accounts"
next
if [[ $(cat /etc/passwd | awk -F: '{print $1}' | grep "stack") == '' ]] ;
   then step "+ Created new user *$USER*" ;
                try useradd stack ;
                try spinner passwd stack;
                echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    else echo "Users are Defined!!"
fi
next

# Update and Install Dependencies
step "+ Adding Repos"
        try silent rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org ;
		    try silent rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

step "+ Running YUM Update"
	      try silent yum update -y -q -e 0
next

step "+ Installing Base Packages and Kernel Update Version"
	      try silent yum --enablerepo=elrepo-kernel install -y -q -e 0 vim net-tools tigervnc-server xorg-x11-fonts-Type1 kernel-ml;
        try silent grub2-set-default 0;
        try silent grub2-mkconfig -o /boot/grub2/grub.cfg

step "+ Configure VNCserver"
        try silent cp /opt/openstack-for-pcf/vnc_service /etc/systemd/system/vncserver@:3.service ;
        try silent mkdir -p /home/stack/.vnc/ ;
        try silent cp /opt/openstack-for-pcf/vnc_stack /home/stack/.vnc/passwd ;
        try silent chmod 600 /home/stack/.vnc/passwd
next

step "+ Start VNCserver"
        try silent systemctl daemon-reload ;
        try silent systemctl start vncserver@:3.service ;
        try silent systemctl enable vncserver@:3.service
next

step "+ Installing KDE Desktop.. This will take some time"
	      try silent yum groups mark convert;
	      try silent yum groupinstall "GNOME Desktop" -y -q -e 0;
next

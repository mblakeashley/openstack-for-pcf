#!/bin/sh
## This script is intended to provision system settings to support OpenStack deployments
USER=stack
CONTROLLER=10.193.93.2
COMPUTE=10.193.93.3
source /opt/openstack-for-pcf/deploy_functions.sh


step "+ Checking user accounts"
next
if [[ $(cat /etc/passwd | awk -F: '{print $1}' | grep "stack") == '' ]] ;
   then step "+ Created new user *$USER*" ;
             try useradd stack ;
             try spinner passwd stack
   else echo "Users are Defined!!"
fi
next

step "+ Adding $USER to Sudoers"
try spinner echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
next

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

step "+ Start VNCserver and Create Password"
try spinner vncserver
next

step "+ Create and Configure VNC Service"
try slient sed -i -e '$a\xvncserver      5900/tcp      # VNC and GDM'
try silent \cp xvncserver /etc/xinetd.d/vncserver
try silent spinner \cp custom.conf /etc/gdm/custom.conf
next

step "+ Configure GNOME Run Level"
try silent spinner ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
next

step "+ Running PackStack"
try silent spinner packstack --answer-file=/opt/openstack-for-pcf/gss_stack_env28.conf
next

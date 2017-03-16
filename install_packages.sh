#!/bin/bash
# This script is intened to install all dependencies pertaining to the openstack-for-pcf project
set -e

## Progress Function to show staus of script
progress_keeper()
{
 while true;do
 echo -n .;sleep 1;done &
 sleep 10 
 kill $!; trap 'kill $!' SIGTERM
 echo done!
}



### Update and Install Dependencies
echo "Running on YUM Update" 
	yum update -y > /dev/null && progress_keeper

echo "Installing Base Packages"
	yum install -y git vim ntp net-utils

echo "Installing GNOME Desktop.. This will take some time"
	yum groupinstall "GNOME Desktop"  -y > /dev/null && progress_keeper

echo "Installing TigerVNC" 
	yum install tigervnc-server xorg-x11-fonts-Type1 -y > /dev/null && progress_keeper



### Install OpenStack YUM Repo and Packstack
echo "Adding OpenStack - Mitaka"
	yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-mitaka/rdo-release-mitaka-6.noarch.rpm && progress_keeper

echo "Installing Packstack"
	yum install -y openstack-packstack && progress_keeper



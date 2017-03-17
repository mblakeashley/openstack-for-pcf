#!/bin/sh
# This script is intened to install all dependencies pertaining to the openstack-for-pcf project
set -e

## Progress Function to show staus of script
progress_keeper()
{
PID=$! #simulate a long process

printf "["
# While process is running...
while kill -0 $PID 2> /dev/null; do
    printf  "."
    sleep 1
done
echo " done!]"
}



### Update and Install Dependencies
echo "*** Running YUM Update ***" 
	yum update -y -q -e 0 > /dev/null & 
	progress_keeper

echo "*** Installing Base Packages ***"
	yum install -y -q -e 0 vim net-tools tigervnc-server xorg-x11-fonts-Type1 -y > /dev/null & 
	progress_keeper

echo "*** Installing GNOME Desktop.. This will take some time ***"
	yum groupinstall "GNOME Desktop"  -y -q -e 0 > /dev/null & 
	progress_keeper



### Install OpenStack YUM Repo and Packstack
echo "*** Adding OpenStack Repo - Mitaka ***"
	yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-mitaka/rdo-release-mitaka-6.noarch.rpm > /dev/null & 
	progress_keeper

echo "*** Installing Packstack *** "
	yum install -y openstack-packstack > /dev/null & 
	progress_keeper
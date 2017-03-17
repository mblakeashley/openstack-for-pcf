#!/bin/sh
set -e

## Create Basic User Account
if ! [ getent passwd stack ]; 
	then useradd stack
    else passwd stack
fi


## Add User to Sudo
echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

## Configure Firewall and Network
sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network


## Start VNCserver and create password
vncserver


## Ping Controller and Compute Host
CONTROLLER=10.193.93.2
COMPUTE=10.193.93.3
ping -c 1 $CONTROLLER 2>/dev/null 1>/dev/null
if [ "$?" = 0 ]
then
  echo "Controller Found!!"
else
  echo "Controller Host Not Found!!"
fi

ping -c 1 $COMPUTE 2>/dev/null 1>/dev/null
if [ "$?" = 0 ]
then
  echo "Compute Host Found!!"
else
  echo "Compute Host Not Found!"
fi







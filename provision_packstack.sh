#!/bin/bash
set -e

## Create Basic User Account
useradd stack
passwd

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






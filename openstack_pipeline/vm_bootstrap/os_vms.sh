#!/bin/sh
#Dependencies for task "deploy-os-vms"

URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz

apt-get update && apt-get install wget -y
wget $URL_TO_BINARY 
gzip -d govc_linux_amd64.gz | cp govc_linux_amd64 /usr/local/bin/govc
chmod +x /usr/local/bin/govc

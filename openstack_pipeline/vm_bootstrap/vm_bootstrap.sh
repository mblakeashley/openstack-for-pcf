#!/bin/bash -x
##BootStrap dependices for OpenStack VM Infrastucture
URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz
URL_TO_EPEL=http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
CONTROLLER=10.193.93.3
COMPUTE=10.193.93.4

## Update and install Dependencies
rpm -iUvh $URL_TO_EPEL;
yum update && yum install ansible git wget openssh-server openssh-clients -y;
wget $URL_TO_BINARY;
gzip -d govc_linux_amd64.gz;
mv govc_linux_amd64 /usr/bin/govc;
chmod +x /usr/bin/govc

ansible --version

# Install our SSH key
#ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
mkdir -m0700 ~/.ssh

cat <<EOF >~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsRuXR5kwbBX45DRrXkZ9nvNAav6X6mJrdXJdgwy0jLR+oDPs+FSWorKK298B2lU8u0d9VaqiilzqztzHsGMzcsT8NpVwCts4gr70VpkFgk0Mc5vjcaDh4q+WDlrQUqQbJ/H+ayc3MqYlb6JFs+3WJDZJB3TIRSVZUKetptzx2ZbQeuSDvNQRYCDOOPTZqmkzuq7KLX5ZbIb+ATkujwQum67ugTK8kv4b3bJql/rsBkq4FMqyG92rh0sLM+xgiWwdjitWp30rzPZTgIwDW2rAcMpfoakl61YYGne/x4wDw80hFmLbiVaALbVeGIqU2jLE8qzdLGCo3YoIsyi4t3yvKw== vagrant@localhost.localdomain
EOF

cat <<EOF >~/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEoQIBAAKCAQEAsRuXR5kwbBX45DRrXkZ9nvNAav6X6mJrdXJdgwy0jLR+oDPs
+FSWorKK298B2lU8u0d9VaqiilzqztzHsGMzcsT8NpVwCts4gr70VpkFgk0Mc5vj
caDh4q+WDlrQUqQbJ/H+ayc3MqYlb6JFs+3WJDZJB3TIRSVZUKetptzx2ZbQeuSD
vNQRYCDOOPTZqmkzuq7KLX5ZbIb+ATkujwQum67ugTK8kv4b3bJql/rsBkq4FMqy
G92rh0sLM+xgiWwdjitWp30rzPZTgIwDW2rAcMpfoakl61YYGne/x4wDw80hFmLb
iVaALbVeGIqU2jLE8qzdLGCo3YoIsyi4t3yvKwIBIwKCAQEAiKBBgGA7TBDzM7No
xRHOnzCuCWVQnt41o76f6MCoic0ROcGoLUiRdjH2F1RDQgc9eoebM3UBC6bDxCao
rKRMQpf1w7Ub6x4kR5qfO31cBW6jNJzUBzL3Zbqm9SF8In6YmyhlLhbwESEVkKHA
vgCd4Wu0rfsA5OJMNufAeWidUBP3qGDnfEc28aZx5zDHkOPHTWliD6I73OPk9pLJ
vzU3cxEVJfZnlaZ4aU+POkHfdRPdw/QVAEgwuVwQefYe7yZtMEDlTZD3lKkv9l81
GkPj7Em584VmgTXC2lmj7wL3YZFcuD4h8SXF5rPfLh49Bgc2AdiI7mgIhqyFCdHR
0Tc3GwKBgQDqu2BoHXuMxKGcpnXk9kocQ2apritAbY7eh9YoaK3W0niEFb62wm8/
8VlDcq1Te6U5MvGBi5h7ZS/B7bkDk/5efV+1rJPrQ51Hu5jS0BAQPahPWQBrP6bE
dO40LzdjfnTyLQvfbwd9DfupWBhaJg2wBIKuYnIC0yB5Gnq5vygtSQKBgQDBJ54x
60gN+fNIljY929tg9n0mHzTxUmhocqS+QXAsWfpYfJzn1a2VKvIFLx4hipU5e4nS
+DN1tpD7BurWC0VqafLDlly9OmrEHUhdfEUNfBfTYlEi1MhzgQJhwVDH40/mIG69
JBSQzr2TcbNT5TgtvF1XW/9+iz4Si/NXR/B80wKBgA1pyv6imViAQ7/O/2wrVLEo
bEQ11pX3ocOSu8fLd6XgJCTOCuXfOY6gE7q2GIhtdyfXBnxuYHwUaSEGRRYltsOS
Irnsmrz8jKUDZ9GIO26kcASIvjIDoyErQM/ILwz/6WzsoZe9M6C++HATqZ7AWI23
HWkM8JJyduJZSNdqAku7AoGAFhMoBbR9Q20F3GjwQZV4KFavN46JtS39TcP1khYb
csh0YeJbEy5c+xrZ1LTtgC0YXldC84oUgntDxOrZAoTx/YhzhBEvK5GlzUUs13vq
onSVAjcfNy5Cy18zeOLkqSFK9bqQUCFhb6KZUq3om9+upiQn7LoOkh6KwEqCNdxV
/6MCgYASOJskpMvfpClM1Yzzp6v+xzdgeK9/nT3yuvqESEbe99LdaVt405lJPKk9
CCf76dGJ+HFwLyzQJJ88dnEMHQuCODlmcB5cG/gGrZpol1cFHuerSi9phfZoD2of
P8Oszj7IqXlEkBMiLFLRfGa0Q9t7jNNTST1fINtdpugfLoXi/Q==
-----END RSA PRIVATE KEY-----
EOF

chmod 0600 /root/.ssh/id_rsa.pub
chmod 0600 /root/.ssh/id_rsa
ls -lart /root/.ssh/
cat /root/.ssh/id_rsa.pub

# Make ansible hosts file, copy and test connection
export ANSIBLE_HOST_KEY_CHECKING=False

cat <<EOF >>hosts
[openstack]
10.193.93.3
EOF

\cp hosts /etc/ansible/

if [[ $(ansible all -m ping | awk -F: '{print $1}' | grep "SUCCESS") ]];
   then echo "Ansible is Ready!"
else exit 1
fi

## Test govc login
# Export govc Variables
export GOVC_URL="https://$USERNAME:$PASSWORD@vcsa-01.haas-59.pez.pivotal.io/sdk"
export GOVC_DATACENTER=Datacenter
export GOVC_INSECURE=true

if ! [[ $(govc about.cert | awk -F: '{print $1}' | grep "vcsa-01.haas-59.pez.pivotal.io") ]] ;
   then "Connection to vSphere.. Success!"
 else exit 1
fi

## Create Base VM's for OpenStack IaaS
govc vm.create -on=false -pool=RP28 -ds=/Datacenter/datastore/LUN01 -c=16 -m=90000 -disk=700GB -net.address=00:50:56:ac:e5:83 -net=env28 gss-lab-28-controller
govc vm.create -on=false -pool=RP28 -ds=/Datacenter/datastore/LUN01 -c=16 -m=90000 -disk=700GB -net.address=00:50:56:ac:e5:14 -net=env28 gss-lab-28-compute
govc vm.change -vm=gss-lab-28-controller -nested-hv-enabled=true
govc vm.change -vm=gss-lab-28-compute -nested-hv-enabled=true
govc vm.power -on=true gss-lab-28-controller
govc vm.power -on=true gss-lab-28-compute

## Allow Base OS to Install
echo "Sleeping until CentOS is installed.."
sleep 6 minutes

## Rebooting VM's after Updates
govc vm.power -reset=true gss-lab-28-controller
govc vm.power -reset=true gss-lab-28-compute

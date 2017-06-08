#!/bin/bash
## Checks and Ansible Deployment to VM Infrastucture
URL_TO_PROJECT=https://github.com/pivotal-gss/openstack-for-pcf.git
URL_TO_BINARY=https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz
URL_TO_EPEL=http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

## Rebooting VM's after CentOS Installation
export GOVC_URL="https://$USERNAME:$PASSWORD@vcsa-01.haas-59.pez.pivotal.io/sdk"
export GOVC_DATACENTER=Datacenter
export GOVC_INSECURE=true

if ! [[ $(govc about.cert | awk -F: '{print $1}' | grep "vcsa-01.haas-59.pez.pivotal.io") ]] ;
   then echo "Connection to vSphere.. Success!"
 else exit 1
fi

govc vm.power -reset=true gss-lab-28-controller
govc vm.power -reset=true gss-lab-28-compute

echo "Sleep for 1 minute, rebooting VM's"
sleep 1m

## Update and install Dependencies
rpm -iUvh $URL_TO_EPEL;
yum update && yum install ansible git wget -y;
wget $URL_TO_BINARY;
gzip -d govc_linux_amd64.gz;
mv govc_linux_amd64 /usr/bin/govc;
chmod +x /usr/bin/govc

## Install our SSH key
mkdir -m0700 ~/.ssh

cat <<EOF >~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8EJKdn7vG3z/OR8XgdhBVB/QWVKmGqhwqH4RpuBEIDdzOLZ5V5/pePF6w/621VdoXnMBtMfX+ADib3o4CxCUO5e9OSepxmEOtWKE7xpzoujYUg7qTI4sE1xT0/pBe9fsR6fJUHcjCuYRSNHyoMeHOviU0mGEcxPXmiXS7buZruXJr1tyYiSihg+x1L6oIk0W7/fpbAvwQoWwXzhUZyQHKWAi0KYRDbOy56QlQ4y2rctbRhAZ8K873MLEyVjbZqNdrfoxy1GjDzlgK8HguWQT/gM/DnJwEwj5sJrZDl8UKX06Db74oDriVjITvgKgZnOnpu0n/gtV/S/LFvd7gFfzN root@c85ecd3062e3
EOF

cat <<EOF >~/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAvBCSnZ+7xt8/zkfF4HYQVQf0FlSphqocKh+EabgRCA3czi2e
Vef6XjxesP+ttVXaF5zAbTH1/gA4m96OAsQlDuXvTknqcZhDrVihO8ac6Lo2FIO6
kyOLBNcU9P6QXvX7EenyVB3IwrmEUjR8qDHhzr4lNJhhHMT15ol0u27ma7lya9bc
mIkooYPsdS+qCJNFu/36WwL8EKFsF84VGckBylgItCmEQ2zsuekJUOMtq3LW0YQG
fCvO9zCxMlY22ajXa36MctRow85YCvB4LlkE/4DPw5ycBMI+bCa2Q5fFCl9Og2++
KA64lYyE74CoGZzp6btJ/4LVf0vyxb3e4BX8zQIDAQABAoIBADahodXENyo4ZDKq
SuM/qNLqso9iHLUP6YqbCT4kyF3MmR4TxnEyKFsDsoY8X9vTir1dPdD6uHkG22r8
JcjL7e/7/56AfmhtUQukOYJB2gcJQPiIo8RmiNXpHR9ma84KKtszWL/yvwVCGxw+
PxAlHXGPbwNuWJeg58YGnDBusOUNw7i0AqDEeBUtwb1uZwLUxOhCJkbVRvV3xgyi
BoV3NxmkWGuQY0LSUucX3Ddruk9rSxu2oPmZVDyUffmdoLvO6DNtl3/DGFpJNpFW
rqF0PzXKgonI858qzwhrBguiu5ua6XAwQkFEdjueARebAyS3w3vHRN0u/QAx5SBL
YYVhSUkCgYEA90pQWAeUfFrJfViOLnUAUVelRJHK8d1BDuKRUC7DrJ30cL6zamYB
UUaEmG8mzHDNhux+VmX3IRbz15Iyc0/8TyWtkm8lhy9X05SPlvwHwGN7iFRaEJQL
v1rAphkw284GPdB/Pr97BwKx3HsjLXRbEQ6vdCaY2xP35qhHyv9p0fMCgYEAwrBA
2Ha4Qi+TNflRTpgDsjFsOkcId8gyFjQUd5Q2Ppkgku5S2/5RGAeXtZrDss8Mw70W
uqchlkO78RNGxkncPczFZmCXq6PFcEjpVo7tWXOTkYyidIZ9quNUR77svmPEVGb4
GkSjMOnnzKiXUS3kLI38aquZq+amdVjcwoOp5j8CgYEA4NASkrTxbMwseWPUfq+n
hkuj196jHZcD2kBn0vlwsrE21HjKK2RotjbhvKLwJtQ2RP8jK/Cu5sozDDvA2cxR
mLKsRX/+IhQMSDG7CIw/j8vhNmNZLdEpjOE4Wshz/qAiVHgD9kul0Q3GHKdlp6Es
WSl8oJ+mPyS8Llm2SvpAfbkCgYAPqhC9mee/Y4aLrDCviymY98MGeVqkEJZ/FNek
u2cV6EonqEdAbhjmPw4kzXv7cg9L3HXstK/OIEsJ3YwvPhgbXNNxJkptw/KJ00P6
8+sC7HquFkun5n5L9ph8YU85DlvokpRZwLYEpH1DCTmLjY6zSwVJK99kZl10SZ8R
g3hzDwKBgGqaureJP3FiP3mGGao9rwdV4cb+fSNVD6/WLDgfAVrBrL2AeRT4J0Dm
CUvJcYlrxMkJROnlIOegmYCGXHuTqfaA6usQmpMNlIIYCbbg+MPceVIjK0SB0ayz
xhNiw67vyLVpfFq1E1UbNepdEwVH5ZDW0j6OF9Q1FE0gx84xQLu9
-----END RSA PRIVATE KEY-----
EOF

chmod 0600 /root/.ssh/id_rsa.pub
chmod 0600 /root/.ssh/id_rsa

## Run Ansible scripts to hosts
export ANSIBLE_HOST_KEY_CHECKING=False

cat <<EOF >>hosts
[openstack-controller]
10.193.93.3

[openstack-compute]
10.193.93.4
EOF

\cp hosts /etc/ansible/

# Clone openstack-for-pcf Repo and run scripts
git clone $URL_TO_PROJECT -b dev_branch
cd openstack-for-pcf

## Testing and Deploy Ansible scripts
if [[ $(ansible all -m ping | awk -F: '{print $1}' | grep "SUCCESS") ]];
   then echo "Ansible is Ready!";
        ansible-playbook deploy_packstack_compute.yml;
        ansible-playbook deploy_packstack_controller.yml

else echo "Do Not Deploy, Ansible is not Ready!"
     exit 1
fi

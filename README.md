# openstack-for-pcf
This Project is meant to automate dependencies for deploying OpenStack + PCF

## Prerequisites

All must be met, otherwise scripts or OpenStack deployment will fail.

* CentOS 7 minimal installed to latest release update.
* Kernel version (≥) 4.0
* 2 VM's 
  * **Controller** - **(2)** NIC's on lab-subnet, **(16)** vCPU with nested enabled via vSphere Web UI, **(90)** GB of RAM and **(700)** GB HDD 
  * **Compute** - **(1)** NIC on lab-subnet, **(16)** vCPU with nested enabled via vSphere Web UI, **(90)** GB of RAM and **(700)** GB HDD


## Scripts

**Run on Contoller only** -
`install_packages.sh` is inteded to install all package and yum repo's for Packstack - OpenStack deployments

script output..
```
[root@contoller openstack-for-pcf]# ./install_packages.sh 
+ Running YUM Update                                       [  OK  ]
+ Installing Base Packages                                 [  OK  ]
+ Installing GNOME Desktop.. This will take some time      [  OK  ]
+ Adding OpenStack Repo - Mitaka                           [  OK  ]
+ Installing Packstack                                     [  OK  ]
```

**Run on Contoller only** -
`provision_packstack.sh` is inteded to provision the Controller VM base OS to support OpenStack + PCF Deployments

script output...
```
[root@contoller openstack-for-pcf]# ./provision_packstack.sh 
+ Checking user accounts                                   [  OK  ]
Changing password for user stack.
New password: 
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: 
passwd: all authentication tokens updated successfully.
                                                           [  OK  ]
+ Adding stack to Sudoers                                  [  OK  ]
+ Configure Firewall and Network                           [  OK  ]
+ Checking SELinux Settings                                [  OK  ]
+ SELinux settings are correct                             [  OK  ]
+ Start VNCserver and create password
New 'contoller:3 (stack)' desktop is contoller:3

Starting applications specified in /root/.vnc/xstartup
Log file is /root/.vnc/contoller:3.log

                                                           [  OK  ]
+ Ping Controller                                          [  OK  ]
+ Ping Compute                                             [  OK  ]
```

**Run on Contoller or Compute** -
`remove_openstack.sh` is used to remove OpenStack installations. This will remove Packstack and all related OpenStack services, does not remove the OpenStack Repo.


## Deploy OpenStack

We are using `packstack` to deploy our OpenStack environment, `gss_stack_env28.conf` is used as a pre-populated template when running the packstack command to deploy.

command usage:
`packstack --answer-file=gss_stack_env28.conf`

The deployment will take 15-20 minutes to complete, depending on current network speeds.


completed output...
```
 **** Installation completed successfully ******


Additional information:
 * Time synchronization installation was skipped. Please note that unsynchronized time on server instances might be problem for some OpenStack components.
 * File /root/keystonerc_admin has been created on OpenStack client host 10.193.93.2. To use the command line tools you need to source the file.
 * To access the OpenStack Dashboard browse to http://10.193.93.2/dashboard .
Please, find your login credentials stored in the keystonerc_admin in your home directory.
 * To use Nagios, browse to http://10.193.93.2/nagios username: nagiosadmin, password: `redacted`
 * Because of the kernel update the host 10.193.93.3 requires reboot.
 * Because of the kernel update the host 10.193.93.2 requires reboot.
 * The installation log file is available at: /var/tmp/packstack/20170321-135711-NtV9ny/openstack-setup.log
 * The generated manifests are available at: /var/tmp/packstack/20170321-135711-NtV9ny/manifests
 ```



#!/bin/bash
set -e

/conjurize.sh
apt-get update -y
chef-solo -r https://github.com/conjur-cookbooks/conjur-ssh/releases/download/v1.2.5/conjur-ssh-v1.2.5.tar.gz -o role[configure]

rm /etc/service/sshd/down
/etc/my_init.d/00_regen_ssh_host_keys.sh 
/etc/service/sshd/run 

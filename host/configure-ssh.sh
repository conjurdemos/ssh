#!/bin/bash
set -e

/conjurize.sh
chef-solo -o role[configure]

rm /etc/service/sshd/down
/etc/my_init.d/00_regen_ssh_host_keys.sh 
/etc/service/sshd/run 

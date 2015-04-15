#!/bin/bash

chmod 0600 /etc/conjur.identity
chef-solo -o recipe[conjur::configure]

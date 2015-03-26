#!/bin/bash
set -e

/conjurize.sh
chef-solo -o role[configure]

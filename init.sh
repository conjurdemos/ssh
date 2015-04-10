#!/bin/bash -e

if ! conjur authn whoami &> /dev/null || [ $(conjur authn whoami | jsonfield username) != demo ]; then
  conjur authn login demo
fi

./init.rb

if [ $(conjur resource exists user:daniel) = false ]; then
  conjur user create --as-group security_admin daniel > daniel.json
fi
if [ $(conjur resource exists group:developers) = false ]; then
  conjur group create --as-group security_admin developers
fi
conjur group members add -a developers daniel

apikey=$(cat daniel.json | jsonfield api_key)
conjur authn login -p ${apikey} -u daniel

# Conjur SSH Demo

This demonstrates Conjur-powered SSH to a host. In this demo, a Docker container running
a pretty complete Ubuntu system is used as the target machine. 

# Running the Demo

## Setup

Create a host:

    $ conjur host create $USER/conjurdemos/ssh | tee host.json

Prepare a host configuration script:

    $ cat host.json | conjurize > host/conjurize.sh

Extract the `login` and `api_key`:

    $ host_id=`cat host.json | jsonfield id`
    $ host_api_key=`cat host.json | jsonfield api_key`

Build the image:

    $ make

Add your SSH key to Conjur. This step assumes that your Conjur login name is the same as the
$USER environment variable.

*Note* By default, SSH will use your SSH key in `~/.ssh/id_rsa`. If you don't have an SSH key there, you should
create one. GitHub provides [good documentation on how to create an SSH key](https://help.github.com/articles/generating-ssh-keys/).

Then load your public key into Conjur:

    $ conjur pubkeys add $USER @~/.ssh/id_rsa.pub

## Run the target machine
    
Run the application container:

    $ docker run -it -e CONJUR_AUTHN_LOGIN=host/$host_id -e CONJUR_AUTHN_API_KEY=$host_api_key -p 2200:22 conjur-ssh

## Login

Now you can login to this machine using your own Conjur login name and SSH key.

Due to the way Docker works, this procedure is a little different depending on whether you are 
using a machine with native Docker support, or you're using Boot2Docker.

### Native (Linux)

Obtain the application hostname:

    $ hostname=`docker inspect conjur-ssh | grep IPAddress | cut -d '"' -f 4`

Login:

    $ ssh -p 2200 $hostname
    # ... a brief pause ...
    
### Boot2Docker

    $ ssh -p 2200 $(boot2docker ip)

## Logged in

Now you're logged in to the target machine! You can inspect your uid and group membership
using the `id` command:

    kgilpin@b7699cfc62a4:/$ id
    uid=1101(kgilpin) gid=50000(conjurers) groups=50000(conjurers)

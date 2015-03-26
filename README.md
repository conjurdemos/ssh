# Conjur SSH Demo

This demonstrates Conjur-powered SSH to a host. In this demo, a Docker container running
a pretty complete Ubuntu system is used as the target machine. 

# Running the Demo

## Setup

Create a host:

    $ conjur host create $USER/conjurdemos/ssh | tee host.json

Make sure there is a Conjur user for you and allow it to login:

    $ conjur user create $USER
    $ conjur resource permit host:$USER/conjurdemos/ssh user:$USER execute

Prepare a host configuration script:

    $ cat host.json | conjurize > conjurize.sh
    $ chmod a+x conjurize.sh

Build the image:

    $ make

Add your SSH key to Conjur. This step assumes that your Conjur login name is the same as the
$USER environment variable.

**Note** By default, SSH will use your SSH key in `~/.ssh/id_rsa`. If you don't have an SSH key there, you should
create one. GitHub provides [good documentation on how to create an SSH key](https://help.github.com/articles/generating-ssh-keys/).

    $ conjur pubkeys add $USER @~/.ssh/id_rsa.pub

## Run the target machine
    
Run the application container, passing its identity credentials:

    $ docker run -it \
      -v $PWD/conjurize.sh:/conjurize.sh \
      -p 2200:22 \
      conjur-ssh

## Login

Now you can login to this machine using your own Conjur login name and SSH key.

Due to the way Docker works, this procedure is a little different depending on whether you are 
using a machine with native Docker support, or you're using Boot2Docker.

### Native (Linux)

Login:

    $ ssh -p 2200 localhost
    
### Boot2Docker

    $ ssh -p 2200 $(boot2docker ip)

## Logged in

Now you're logged in to the target machine! You can inspect your uid and primary group
using the `id` command:

    kgilpin@b7699cfc62a4:/$ id
    uid=1101(kgilpin) gid=50000(conjurers) groups=50000(conjurers)

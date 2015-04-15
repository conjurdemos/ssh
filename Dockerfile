FROM phusion/baseimage:0.9.16

# Enable SSH
RUN rm /etc/service/sshd/down
RUN locale-gen en_US.UTF-8

ADD conjur.conf /etc/conjur.conf
ADD conjur-demo.pem /etc/conjur-demo.pem
ADD Berksfile /Berksfile

RUN cd /tmp && curl -o chefdk.deb https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.4.0-1_amd64.deb && dpkg -i chefdk.deb

RUN LANG=en_US.UTF-8 berks vendor -b /Berksfile /var/chef/cookbooks

RUN chef-solo -o recipe[conjur::install]

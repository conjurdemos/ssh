FROM phusion/baseimage:0.9.16

# Install Chef to run the SSH configuration cookbooks
RUN cd /tmp && \
  curl -o chef.deb https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/13.04/x86_64/chef_12.0.3-1_amd64.deb && \
  dpkg -i chef.deb

# Add Chef roles for package install and final configuration
ADD roles /var/chef/roles

# Install Chef
RUN chef-solo -r https://github.com/conjur-cookbooks/conjur-ssh/releases/download/v1.2.5/conjur-ssh-v1.2.5.tar.gz -o role[install]
RUN /opt/chef/embedded/bin/gem install netrc --no-rdoc --no-ri

# Standard image entry point
CMD ["/sbin/my_init"]

# Enable the ssh daemon
RUN rm /etc/service/sshd/down

# Add script to finish the SSH configuration
ADD configure-ssh.sh /etc/my_init.d/10_configure-ssh.sh

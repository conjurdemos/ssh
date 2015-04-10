FROM phusion/baseimage:0.9.16

# Enable SSH
RUN rm /etc/service/sshd/down

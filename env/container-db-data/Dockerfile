FROM alpine
MAINTAINER Taras Shabatyn <tshabatyn@magento.com>

ENV TERM=xterm-256color

# add openssh and clean
RUN apk add --update openssh \
&& rm  -rf /tmp/* /var/cache/apk/*
#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -A

# Cleaning apk cache
RUN rm  -rf /tmp/* /var/cache/apk/*

COPY ./ssh /root/.ssh
COPY ./ssh/support.pub /root/.ssh/authorized_keys
RUN chmod -R 400 /root/.ssh

COPY ./env/.my.cnf /root/.my.cnf:ro
ADD ./env/mysql/conf.d/ /etc/mysql/conf.d/

RUN mkdir -p /var/lib/mysql

WORKDIR /var/lib/mysql

ADD docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

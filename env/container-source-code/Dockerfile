FROM alpine
MAINTAINER Taras Shabatyn <tshabatyn@magento.com>

ENV TERM=xterm-256color

# add openssh and clean
RUN apk add --update openssh git curl \
&& rm  -rf /tmp/* /var/cache/apk/*
#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -A

# Cleaning apk cache
RUN rm  -rf /tmp/* /var/cache/apk/*

COPY ./ssh /root/.ssh
COPY ./ssh/support.pub /root/.ssh/authorized_keys
RUN chmod -R 400 /root/.ssh

RUN mkdir -p /var/www
COPY ./src /var/www

RUN mkdir /var/www/xhgui \
    && git clone https://github.com/perftools/xhgui.git /var/www/xhgui

RUN cd /var/www \
    && curl -Lo ioncube_loaders_lin_x86-64.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar xvfz ioncube_loaders_lin_x86-64.tar.gz \
    && chown -R root. ioncube \
    && chmod a+x ioncube/*.so

WORKDIR /var/www

ADD docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

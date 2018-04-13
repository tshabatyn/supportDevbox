#!/usr/bin/env sh

git config --global user.email "tshabatyn@magento.com"
git config --global user.name "Taras Shabatyn"

cd /var/www/xhgui && git stash
cd /var/www/xhgui && git pull
cd /var/www/xhgui && git stash pop

/usr/sbin/sshd -D

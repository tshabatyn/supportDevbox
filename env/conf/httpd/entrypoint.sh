#!/usr/bin/env bash

ln -s /opt/data/magento1 /var/www/
ln -s /opt/data/magento2 /var/www/

httpd-foreground

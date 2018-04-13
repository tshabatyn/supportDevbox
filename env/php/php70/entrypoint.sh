#!/usr/bin/env bash

service ssh stop
service ssh start

export PHP_IDE_CONFIG="serverName=magento.local"

php-fpm -R

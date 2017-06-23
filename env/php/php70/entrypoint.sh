#!/usr/bin/env bash

if [ ! -f /var/www/xhgui/vendor/autoload.php ] || [ ! -f /var/www/xhgui/composer.phar ]; then
    composer install -d /var/www/xhgui
fi

if [ ! -f /var/www/xhgui/config/config.php ]; then
    cp /var/www/env/xhgui/config/config.php /var/www/xhgui/config/config.php
fi

service ssh stop
service ssh start

export PHP_IDE_CONFIG="serverName=magento.local"

php-fpm -R

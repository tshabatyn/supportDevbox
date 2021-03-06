FROM php:7.1-fpm
MAINTAINER Taras Shabatyn <tshabatyn@magento.com>

ENV TERM=xterm-256color
ENV COMPOSER_PROCESS_TIMEOUT 2000

RUN apt-get update && apt-get install -y \
    vim \
    git \
    mysql-client \
    openssh-server \
    curl \
    msmtp \
    patch \
    pv \
    bash-completion \
    less

RUN apt-get install -y libmagickwand-6.q16-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libicu-dev \
    libxslt-dev \
    libgringotts-dev \
    libcurl4-openssl-dev \
    --no-install-recommends

ARG php_ext

RUN docker-php-ext-install -j$(nproc) $php_ext
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-mhash \
    && docker-php-ext-install -j$(nproc) gd
RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN pecl install oauth-1.2.3 && docker-php-ext-enable oauth

RUN ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin/ \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN pecl install lzf && docker-php-ext-enable lzf

RUN apt-get purge -y libmagickwand-6.q16-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libicu-dev \
    libxslt-dev \
    libgringotts-dev \
    libcurl4-openssl-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./etc/php/conf.d/production-php.ini $PHP_INI_DIR/php.ini

COPY ./etc/php/php-fpm.d/development-www.conf /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/www-data/root/g' /usr/local/etc/php-fpm.d/www.conf

RUN sed -i 's/UMASK\s*022/UMASK\t002/' /etc/login.defs
RUN echo 'umask 002' >> /etc/profile
RUN echo 'alias ll="ls -lA"' >>/root/.bashrc

RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN echo "xdebug.remote_enable=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=\"PHPSTORM\"" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.max_nesting_level=100000" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.show_local_vars=0" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.var_display_max_data=10000" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.var_display_max_depth=20" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host=\"10.254.254.254\"" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.show_exception_trace=0" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.remote_handler=\"dbgp\"" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.profiler_enable_trigger=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.profiler_output_dir = "/var/www/magento2/var/tmp"" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini

RUN echo "opcache.max_accelerated_files=7963" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.memory_consumption=192MB" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.validate_timestamps=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.revalidate_freq=60" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.interned_strings_buffer=16" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.fast_shutdown=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini

RUN curl -o /usr/local/bin/n98-magerun2 https://files.magerun.net/n98-magerun2.phar \
    && chmod +x /usr/local/bin/n98-magerun2

RUN ln -s /usr/local/bin/php /usr/bin/php

RUN mkdir -p /etc/bash_completion.d/
RUN curl -o /etc/bash_completion.d/magento2-bash-completion https://raw.githubusercontent.com/yvoronoy/magento2-bash-completion/master/magento2-bash-completion
RUN curl -o /etc/bash_completion.d/magento2-bash-completion-enterprise https://raw.githubusercontent.com/yvoronoy/magento2-bash-completion/master/magento2-bash-completion-enterprise
RUN echo "if [ -f /etc/bash_completion ]; then" >> /etc/profile
RUN echo " . /etc/bash_completion" >> /etc/profile
RUN echo "fi" >> /etc/profile

ENV PHP_IDE_CONFIG="serverName=magento.local"

WORKDIR /var/www/magento2

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm", "-R"]

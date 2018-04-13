FROM php:5.6-fpm
MAINTAINER Taras Shabatyn <tshabatyn@magento.com>

ENV REVISION=1
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
    pkg-config \
    libssl-dev \
    libpcre3-dev \
    --no-install-recommends

ARG php_ext

RUN docker-php-ext-install -j$(nproc) $php_ext
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-mhash \
    && docker-php-ext-install -j$(nproc) gd
RUN pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug

RUN pecl install oauth-1.2.3 && docker-php-ext-enable oauth

RUN ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin/ \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN pecl install lzf && docker-php-ext-enable lzf

RUN pecl install mongodb && docker-php-ext-enable mongodb

RUN echo 'deb http://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages debian main' > /etc/apt/sources.list.d/tideways.list \
    && curl https://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages/EEB5E8F4.gpg | apt-key add - \
    && apt-get update && apt-get install -y \
    tideways-php \
    tideways-daemon \
    && docker-php-ext-enable tideways \
    && sed -i'' -e 's/^extens/;extens/g' $PHP_INI_DIR/conf.d/docker-php-ext-tideways.ini \
    && echo -e "tideways.auto_prepend_library=0\ntideways.framework=magento2\n" >> $PHP_INI_DIR/conf.d/docker-php-ext-tideways.ini

RUN apt-get purge -y libmagickwand-6.q16-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libicu-dev \
    libxslt-dev \
    libgringotts-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    libpcre3-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -Lo /usr/local/bin/n98-magerun https://files.magerun.net/n98-magerun.phar \
    && chmod +x /usr/local/bin/n98-magerun

RUN curl -Lo /usr/local/bin/n98-magerun2 https://files.magerun.net/n98-magerun2.phar \
    && chmod +x /usr/local/bin/n98-magerun2

#COPY ./etc/php/conf.d/production-php.ini $PHP_INI_DIR/php.ini
COPY ./etc/php/conf.d/development-php.ini $PHP_INI_DIR/php.ini

RUN ln -s /usr/local/bin/php /usr/bin/php

RUN mkdir -p /etc/bash_completion.d/
RUN curl -Lo /etc/bash_completion.d/magento2-bash-completion https://raw.githubusercontent.com/yvoronoy/magento2-bash-completion/master/magento2-bash-completion
RUN curl -Lo /etc/bash_completion.d/magento2-bash-completion-enterprise https://raw.githubusercontent.com/yvoronoy/magento2-bash-completion/master/magento2-bash-completion-enterprise
RUN curl -Lo /etc/bash_completion.d/n98-magerun2.phar.bash https://raw.githubusercontent.com/netz98/n98-magerun2/master/res/autocompletion/bash/n98-magerun2.phar.bash

RUN curl -Lo /usr/local/bin/phpcs https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && chmod a+x /usr/local/bin/phpcs \
    ; curl -Lo /usr/local/bin/phpcbf https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
    && chmod a+x /usr/local/bin/phpcbf \
    ; curl -Lo /usr/local/bin/phpmd http://static.phpmd.org/php/latest/phpmd.phar \
    && chmod a+x /usr/local/bin/phpmd \
    ; curl -Lo /usr/local/bin/codecept http://codeception.com/php5/codecept.phar \
    && chmod a+x /usr/local/bin/codecept

#we need it for tideways
RUN sed -i 's%auto_prepend_file =%auto_prepend_file = "/var/www/xhgui/external/header.php"%g' /usr/local/etc/php/php.ini
#we need it for tideways

COPY ./etc/php/php-fpm.d/development-www.conf /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/www-data/root/g' /usr/local/etc/php-fpm.d/www.conf

RUN sed -i 's/UMASK\s*022/UMASK\t002/' /etc/login.defs
RUN echo 'umask 002' >> /etc/profile
RUN echo echo 'alias ll="ls -lA"' >> /root/.bashrc \
    ; echo 'alias lt="ls -lth"' >> /root/.bashrc \
    ; echo 'alias ltr="ls -ltrh"' >> /root/.bashrc

RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed -i'' -e 's/^zend/;zend/g' $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_enable=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=\"PHPSTORM\"" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.max_nesting_level=10000" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.show_local_vars=0" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.var_display_max_data=10000" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.var_display_max_depth=20" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host=\"10.254.254.254\"" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.show_exception_trace=0" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.remote_handler=\"dbgp\"" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.profiler_enable_trigger=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.profiler_output_dir = "/var/www/magento1/var/tmp"" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini

RUN echo "opcache.max_accelerated_files=7963" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.memory_consumption=192MB" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.validate_timestamps=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.revalidate_freq=60" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.interned_strings_buffer=16" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.fast_shutdown=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini

RUN echo "if [ -f /etc/bash_completion ]; then" >> /root/.bashrc \
    && echo " . /etc/bash_completion" >> /root/.bashrc \
    && echo "fi" >> /root/.bashrc

RUN ln -s /usr/local/bin/tideways-php.sh /usr/local/bin/profiler.sh \
    ; ln -s /usr/local/bin/tideways-php.sh /usr/local/bin/php-profiler.sh \
    ; ln -s /usr/local/bin/xdebug-php.sh /usr/local/bin/debugger.sh \
    ; ln -s /usr/local/bin/xdebug-php.sh /usr/local/bin/php-debugger.sh \
    ; ln -s /usr/local/bin/ioncube-php.sh /usr/local/bin/php-ioncube.sh

RUN echo ";zend_extension=/var/www/ioncube/ioncube_loader_lin_5.6.so" > $PHP_INI_DIR/conf.d/docker-php-ext-ioncube.ini

ENV PHP_IDE_CONFIG="serverName=magento.local"

WORKDIR /var/www/magento1

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm", "-R"]

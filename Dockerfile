FROM ubuntu:xenial

ENV PHP_VERSION=7.0

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update  \
    && apt-get install -y php${PHP_VERSION} php${PHP_VERSION}-xml php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-fpm php${PHP_VERSION}-cli php${PHP_VERSION}-json \
        php${PHP_VERSION}-curl php${PHP_VERSION}-gd php${PHP_VERSION}-mysqlnd \
        php${PHP_VERSION}-imap php${PHP_VERSION}-mcrypt php${PHP_VERSION}-zip \
        php${PHP_VERSION}-intl php${PHP_VERSION}-dev \
        pkg-config php-pear libcurl4-openssl-dev libssl-dev libsslcommon2-dev   \
    && pecl install mongodb  \
    && echo "extension=mongodb.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"` \
    && echo "extension=mongodb.so" >> /etc/php/${PHP_VERSION}/fpm/php.ini \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

FROM ubuntu:xenial

ENV PHP_VERSION=7.3
ARG SWOOLE_VERSION=4.4.4
ARG MONGODB_VERSION=1.5.5

RUN apt-get update \
    && apt-get install -y gzip zip unzip zlib-dev build-essential curl \
    software-properties-common language-pack-pt-base language-pack-en-base \
    && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php${PHP_VERSION} php${PHP_VERSION}-xml php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-fpm php${PHP_VERSION}-cli php${PHP_VERSION}-json \
        php${PHP_VERSION}-curl php${PHP_VERSION}-gd php${PHP_VERSION}-imap \
        php${PHP_VERSION}-zip php${PHP_VERSION}-intl php${PHP_VERSION}-dev \
        php${PHP_VERSION}-bcmath pkg-config php-pear libcurl4-openssl-dev libssl-dev \
        libsslcommon2-dev 

RUN pecl install mongodb-${MONGODB_VERSION} \
    && echo "extension=mongodb.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"` \
    && echo "extension=mongodb.so" >> /etc/php/${PHP_VERSION}/fpm/php.ini \
    && pecl install swoole-${SWOOLE_VERSION} \
    && echo "extension=swoole.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"` \
    && echo "extension=swoole.so" >> /etc/php/${PHP_VERSION}/fpm/php.ini \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get autoremove -yqq --purge \
    && apt-get clean
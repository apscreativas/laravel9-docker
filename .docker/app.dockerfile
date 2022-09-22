FROM php:8.1.3-fpm-alpine

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# system dependencies
RUN apk --update add wget \
    curl \
    git \
    grep \
    build-base \
    libmemcached-dev \
    libmcrypt-dev \
    libxml2-dev \
    imagemagick-dev \
    pcre-dev \
    libtool \
    make \
    autoconf \
    g++ \
    cyrus-sasl-dev \
    libgsasl-dev \
    libpq-dev \
    supervisor

# php extensions
RUN docker-php-ext-install pdo pdo_pgsql xml
RUN pecl channel-update pecl.php.net \
    && pecl install memcached \
    && pecl install imagick \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable imagick

RUN rm /var/cache/apk/* && \
    mkdir -p /var/www

COPY conf/supervisord-app.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
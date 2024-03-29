FROM php:8.1.3-cli-alpine

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
    libpq-dev \
    make \
    autoconf \
    g++ \
    cyrus-sasl-dev \
    libgsasl-dev

# php extensions
RUN docker-php-ext-install pdo pdo_pgsql xml
RUN pecl channel-update pecl.php.net \
    && pecl install memcached \
    && pecl install imagick \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable imagick

RUN rm /var/cache/apk/* && \
    mkdir -p /var/www

# command
CMD ["/usr/local/bin/php"]
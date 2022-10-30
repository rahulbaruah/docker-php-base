FROM php:7.4.32-fpm-alpine3.15

# ENV NGINX_VERSION 1.20.2
# ENV NJS_VERSION   0.7.0
# ENV PKG_RELEASE   1

# install necessary alpine packages
RUN apk update && apk add --no-cache \
    zip \
    unzip \
    dos2unix \
    supervisor \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    freetype-dev \
    $PHPIZE_DEPS \
    libjpeg-turbo-dev \
    curl \
    jpegoptim optipng pngquant gifsicle \
    git

# compile native PHP packages
RUN docker-php-ext-install \
    gd \
    exif \
    pcntl \
    bcmath \
    mysqli \
    pdo_mysql

# configure packages
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# install additional packages from PECL
RUN pecl install zip && docker-php-ext-enable zip \
    && pecl install igbinary && docker-php-ext-enable igbinary \
    && yes | pecl install redis && docker-php-ext-enable redis

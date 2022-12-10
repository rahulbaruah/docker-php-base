FROM php:8.1.3-fpm-alpine3.15

# install necessary alpine packages
RUN apk update && apk add --no-cache \
    $PHPIZE_DEPS \
    zip \
    unzip \
    dos2unix \
    supervisor \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    freetype-dev \
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
    && yes | pecl install redis && docker-php-ext-enable redis \
    && pecl install xdebug-3.1.6 && docker-php-ext-enable xdebug


# set composer related environment variables
ENV PATH="/composer/vendor/bin:$PATH" \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --ansi --version --no-interaction
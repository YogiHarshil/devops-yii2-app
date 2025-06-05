FROM php:8.1-apache

RUN apt update && apt install -y git unzip zip curl libzip-dev
RUN docker-php-ext-install pdo pdo_mysql

# Enable Apache rewrite
RUN a2enmod rewrite

# Copy app
COPY ./yii2-app /var/www/html

# Set correct document root to Yii2's /web folder
RUN sed -i 's|/var/www/html|/var/www/html/web|g' /etc/apache2/sites-available/000-default.conf

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

# Optional: Composer install
WORKDIR /var/www/html
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN composer install --no-interaction --prefer-dist

EXPOSE 80

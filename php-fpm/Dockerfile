FROM php:7.4.20-fpm-alpine3.13
ARG VERSION=3.0.2

WORKDIR /var/www/html

RUN docker-php-ext-install pdo_mysql
RUN curl -L https://github.com/omeka/omeka-s/releases/download/v${VERSION}/omeka-s-${VERSION}.zip --output omeka.zip \
    && unzip omeka.zip \
    && mv omeka-s/* . \
    && rm -rf omeka.zip omeka-s
COPY config/ application/config/
RUN chown -R www-data files/

EXPOSE 9000

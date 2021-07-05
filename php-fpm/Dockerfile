# See https://omeka.org/s/docs/user-manual/install/.
# Stick to Alpine 3.13 to prevent https://github.com/alpinelinux/docker-alpine/issues/182.
FROM php:7.4.20-fpm-alpine3.13
ARG VERSION=3.0.2

WORKDIR /var/www/html

COPY --from=mlocati/php-extension-installer:1.2.36 /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd pdo_mysql

RUN curl -L https://github.com/omeka/omeka-s/releases/download/v${VERSION}/omeka-s-${VERSION}.zip --output omeka.zip \
    && unzip omeka.zip \
    && mv omeka-s/* . \
    && rm -rf omeka.zip omeka-s
COPY config/application.config.php application/config/
COPY config/local.config.php config/
RUN chown -R www-data files/ logs/

RUN curl -L https://github.com/Xentropics/ValueSuggest/archive/refs/heads/ndeterms.zip --output ndeterms.zip \
    && unzip ndeterms.zip \
    && mv ValueSuggest-ndeterms modules/ValueSuggest \
    && rm ndeterms.zip

EXPOSE 9000

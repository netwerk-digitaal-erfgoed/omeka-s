FROM php:8.3.20-fpm-alpine AS php-fpm
ARG VERSION=4.1.1
WORKDIR /var/www/html
COPY --from=mlocati/php-extension-installer:2.7.31 /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions imagick pdo_mysql
RUN curl -L https://github.com/omeka/omeka-s/releases/download/v${VERSION}/omeka-s-${VERSION}.zip --output omeka.zip \
    && unzip omeka.zip \
    && mv omeka-s/* . \
    && rm -rf omeka.zip omeka-s
RUN curl -L https://github.com/Xentropics/ValueSuggest/archive/refs/heads/ndeterms.zip --output ndeterms.zip \
    && unzip ndeterms.zip \
    && mv ValueSuggest-ndeterms modules/ValueSuggest \
    && rm ndeterms.zip
RUN chown -R www-data files/ logs/
COPY php-fpm/config/application.config.php application/config/
COPY php-fpm/config/local.config.php config/
EXPOSE 9000

FROM nginx:stable-alpine AS nginx
WORKDIR /var/www/html
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=php-fpm /var/www/html/index.php ./
COPY --from=php-fpm /var/www/html/application/asset ./application/asset
COPY --from=php-fpm /var/www/html/modules ./modules
COPY --from=php-fpm /var/www/html/themes ./themes
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

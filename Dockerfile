FROM php:8.3.20-fpm-alpine AS php-fpm
ARG VERSION=4.1.1
WORKDIR /var/www/html
RUN apk add --no-cache vips
COPY php-fpm/php.ini /usr/local/etc/php/conf.d/php-overrides.ini
COPY --from=mlocati/php-extension-installer:2.7.31 /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions imagick pdo_mysql
RUN curl -L https://github.com/omeka/omeka-s/releases/download/v${VERSION}/omeka-s-${VERSION}.zip --output omeka.zip \
    && unzip omeka.zip \
    && mv omeka-s/* . \
    && rm -rf omeka.zip omeka-s
RUN cd modules \
    && for module in https://github.com/Daniel-KM/Omeka-S-module-Common/releases/download/3.4.66/Common-3.4.66.zip \
    https://github.com/Daniel-KM/Omeka-S-module-EasyAdmin/releases/download/3.4.30/EasyAdmin-3.4.30.zip \
    https://github.com/omeka-s-modules/NdeTermennetwerk/releases/download/v1.1.0/NdeTermennetwerk-1.1.0.zip \
    https://github.com/netwerk-digitaal-erfgoed/Omeka-S-Module-LinkedDataSets/releases/download/v0.2/LinkedDataSets.zip \
    https://github.com/Daniel-KM/Omeka-S-module-ImageServer/releases/download/3.6.19/ImageServer-3.6.19.zip \
    https://github.com/Daniel-KM/Omeka-S-module-IiifServer/releases/download/3.6.24/IiifServer-3.6.24.zip \
    https://github.com/omeka-s-modules/UriDereferencer/releases/download/v1.4.2/UriDereferencer-1.4.2.zip \
    https://github.com/Daniel-KM/Omeka-S-module-Log/releases/download/3.4.27/Log-3.4.27-php-8.2.zip \
    https://github.com/omeka-s-modules/NumericDataTypes/releases/download/v1.12.0/NumericDataTypes-1.12.0.zip \
    https://github.com/omeka-s-modules/CustomVocab/releases/download/v2.0.2/CustomVocab-2.0.2.zip \
    ; do \
    curl -L $module --output module.zip \
      && unzip module.zip \
      && rm module.zip; \
done
RUN cd themes \
    && for theme in https://github.com/omeka-s-themes/foundation-s/releases/download/v1.5.3/theme-foundation-s-v1.5.3.zip \
    ; do \
    curl -L $theme --output theme.zip \
      && unzip theme.zip \
      && rm theme.zip; \
done

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

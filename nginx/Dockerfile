FROM nginx:stable-alpine
ARG VERSION=3.0.2

WORKDIR /var/www/html

RUN curl -L https://github.com/omeka/omeka-s/releases/download/v${VERSION}/omeka-s-${VERSION}.zip --output omeka.zip \
    && unzip omeka.zip \
    && mv omeka-s/index.php . \
    && mkdir application/ \
    && mv omeka-s/application/asset application/asset \
    && rm -rf omeka.zip omeka-s
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

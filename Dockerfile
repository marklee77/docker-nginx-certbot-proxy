FROM marklee77/supervisor:alpine
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN apk add --update-cache --no-cache \
        certbot \
        nginx \
        openssl && \
    rm -rf /etc/nginx/conf.d/* /var/cache/apk/* /var/www/* && \
    cd /etc/nginx && rm *.conf *_params koi-* win-*

COPY root/etc/supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/
RUN chmod 0644 /etc/supervisor/conf.d/nginx.conf

COPY root/etc/nginx/nginx.conf /etc/nginx/nginx.conf
RUN chmod 0644 /etc/nginx/nginx.conf

COPY root/etc/nginx/snippets/* /etc/nginx/snippets/
RUN chmod 0644 /etc/nginx/snippets/*

COPY root/etc/my_init.d/10-nginx-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/10-nginx-setup

VOLUME ["/etc/letsencrypt", "/var/log/nginx", "/var/www"]

EXPOSE 80 443

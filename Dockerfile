FROM marklee77/supervisor:alpine
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN apk add --update-cache --no-cache \
        certbot \
        nginx && \
    rm -rf /etc/nginx/conf.d/* /var/cache/apk/* /var/www/*

COPY root/etc/supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/
RUN chmod 0644 /etc/supervisor/conf.d/nginx.conf

COPY root/etc/nginx/nginx.conf /etc/nginx/nginx.conf
RUN chmod 0644 /etc/nginx/nginx.conf

COPY root/etc/my_init.d/10-nginx-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/10-nginx-setup

RUN mkdir -m 0755 -p /var/www/default/htdocs

VOLUME ["/var/log/nginx"]

EXPOSE 80 443

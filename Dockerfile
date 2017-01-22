FROM marklee77/supervisor:alpine
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN apk add --update --no-cache \
    certbot \
    nginx

COPY root/etc/supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/
RUN chmod 0644 /etc/supervisor/conf.d/nginx.conf

COPY root/etc/my_init.d/10-nginx-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/10-nginx-setup

EXPOSE 80 443

FROM marklee77/supervisor:alpine
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN apk add --update-cache --no-cache \
        ca-certificates \
        certbot \
        nginx \
        openssl && \
    rm -rf /etc/nginx/conf.d/* /var/cache/apk/* /var/www/* && \
    cd /etc/nginx && rm -r conf.d *.conf *_params koi-* modules win-*

COPY root/etc/supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/
RUN chmod 0644 /etc/supervisor/conf.d/nginx.conf

COPY root/etc/nginx/nginx.conf /etc/nginx/nginx.conf
RUN chmod 0644 /etc/nginx/nginx.conf

RUN mkdir -p -m 0700 /var/cache/nginx && \
    chown -R nginx:nginx /var/cache/nginx
RUN mkdir -p -m 0755 /etc/nginx/sites

COPY root/etc/nginx/snippets/* /etc/nginx/snippets/
RUN chmod 0644 /etc/nginx/snippets/*

COPY root/etc/my_init.d/10-nginx-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/10-nginx-setup

VOLUME ["/etc/letsencrypt", "/var/cache/nginx", "/var/log/nginx", "/var/www"]

EXPOSE 80 443

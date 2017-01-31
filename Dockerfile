FROM marklee77/supervisor:alpine
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN apk add --update-cache --no-cache \
        ca-certificates \
        certbot \
        nginx \
        openssl \
        py-mako && \
    rm -rf /etc/nginx/conf.d/* /var/cache/apk/* /var/www/* && \
    cd /etc/nginx && rm -r conf.d *.conf *_params koi-* modules win-*

COPY root/etc/supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/
RUN chmod 0644 /etc/supervisor/conf.d/nginx.conf

COPY root/etc/nginx/nginx.conf /etc/nginx/
RUN chmod 0644 /etc/nginx/nginx.conf

RUN mkdir -p -m 0700 /var/cache/nginx && \
    chown -R nginx:nginx /var/cache/nginx
RUN cd /etc/nginx && mkdir -p -m 0755 http-servers https-servers

COPY root/etc/nginx/snippets/* /etc/nginx/snippets/
RUN chmod 0644 /etc/nginx/snippets/*

COPY root/etc/my_init.d/10-nginx-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/10-nginx-setup

RUN mkdir -p -m 0755 /var/lib/certbot-webroot

VOLUME ["/etc/letsencrypt", "/var/log/nginx", "/var/www"]

EXPOSE 80 443

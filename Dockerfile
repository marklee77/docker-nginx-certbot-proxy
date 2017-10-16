FROM marklee77/supervisor:alpine
MAINTAINER Mark Stillwell <mark@stillwell.me>

RUN apk add --update-cache --no-cache \
        ca-certificates \
        certbot \
        nginx \
        openssl \
        py-mako && \
    rm -rf \
        /etc/nginx/*.conf \
        /etc/nginx/*_params \
        /etc/nginx/conf.d \
        /etc/nginx/modules \
        /var/cache/apk/* \
        /var/cache/nginx/* \
        /var/log/letsencrypt \
        /var/log/nginx \
        /var/www

RUN mkdir -m 0755 -p /etc/ssl/nginx && \
    ln -s /data/nginx/ssl/dh4096.pem /etc/ssl/nginx/dh4096.pem

RUN ln -s /data/certbot/config.d /etc/letsencrypt && \
    ln -s /data/certbot/log /var/log/letsencrypt && \
    ln -s /data/certbot/webroot /var/lib/certbot-webroot

RUN mkdir -m 0755 -p /etc/nginx/snippets

COPY root/etc/nginx/nginx.conf /etc/nginx/
RUN chmod 0644 /etc/nginx/nginx.conf
COPY root/etc/nginx/snippets/* /etc/nginx/snippets/
RUN chmod 0644 /etc/nginx/snippets/*

RUN ln -s /data/nginx/config.d/http-configs /etc/nginx/http-configs && \
    ln -s /data/nginx/config.d/https-configs /etc/nginx/https-configs && \
    ln -s /data/nginx/config.d/snippets/resolvers /etc/nginx/snippets/resolvers && \
    ln -s /data/nginx/log /var/log/nginx && \
    ln -s /data/nginx/www /var/www

COPY root/usr/local/share/nginx-server-manage/templates/* \
         /usr/local/share/nginx-server-manage/templates/
RUN chmod -R u=rwX,g=rX,o=rX /usr/local/share/nginx-server-manage
COPY root/usr/local/sbin/nginx-server-manage /usr/local/sbin/
RUN chmod 0755 /usr/local/sbin/nginx-server-manage

COPY root/etc/periodic/daily/certbot-renew /etc/periodic/daily/
RUN chmod 0755 /etc/periodic/daily/certbot-renew

COPY root/etc/my_init.d/10-nginx-setup /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/10-nginx-setup

COPY root/etc/supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/
RUN chmod 0644 /etc/supervisor/conf.d/nginx.conf

EXPOSE 80 443

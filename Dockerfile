FROM marklee77/supervisor:alpine
LABEL maintainer="Mark Stillwell <mark@stillwell.me>"

RUN apk add --update-cache --no-cache \
        ca-certificates \
        certbot \
        nginx \
        openssl \
        py2-future \
        py2-mako && \
    rm -rf \
        /etc/nginx/*.conf \
        /etc/nginx/*_params \
        /etc/nginx/conf.d \
        /etc/nginx/modules \
        /var/cache/apk/* \
        /var/log/letsencrypt/* \
        /var/log/nginx/* \
        /var/www/* && \
    ln -s /dev/stdout /var/log/nginx/error.log && \
    mkdir -m 0755 -p /etc/nginx/servers && \
    mkdir -m 0770 -p /var/cache/nginx && \
    chown nginx:nginx /var/cache/nginx && \
    mkdir -m 0755 -p /var/www/certbot

COPY root/etc/ssl/dhparam/ffdhe4096.pem /etc/ssl/dhparam/
RUN chmod 0444 /etc/ssl/dhparam/ffdhe4096.pem

COPY root/etc/nginx/snippets/* /etc/nginx/snippets/
RUN chmod 0644 /etc/nginx/snippets/*

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

VOLUME ["/etc/letsencrypt"]

server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name ${server_name};

  ssl_certificate /etc/letsencrypt/live/${server_name}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${server_name}/privkey.pem;

  include snippets/headers;

  %if hsts_max_age > 0:
  add_header Strict-Transport-Security "max-age=${hsts_max_age}; includeSubDomains" always;

  %endif
  location / {
    %if proxy is not None:
    proxy_pass ${proxy};
    include snippets/proxy;
    %elif redirect is not None:
    return 301 ${redirect};
    %elif directory is not None:
    root ${directory};
    %endif
  }
}

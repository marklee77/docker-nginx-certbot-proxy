server {
  listen 80 default_server;
  listen [::]:80 default_server;
  server_name ${server_name};

  include snippets/headers;

  location /.well-known {
    root /var/lib/certbot-webroot/${server_name};
  }

  location / {
    return 301 https://$server_name$request_uri;
  }
}

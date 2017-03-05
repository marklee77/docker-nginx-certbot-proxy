server {
  listen 80${" default_server" if default else ""};
  listen [::]:80${" default_server" if default else ""};
  server_name ${server_name};

  include snippets/headers;

  location /.well-known {
    root ${webroot_path};
  }

  location / {
    return 301 https://$server_name$request_uri;
  }
}

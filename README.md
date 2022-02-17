# outline-docker-compose

Install a self-hosted [Outline](https://github.com/outline/outline) wiki instance in a couple of minutes.

## Features:

1. A simple make and bash script to help you generate all the conf required
1. A docker-compose to run your service
1. Use [MinIO](https://github.com/minio/minio) instead of AWS S3, so that everything is really self-hosted
1. A [OIDC server](https://github.com/vicalloy/oidc-server) to manage user, no need to login via slack or google

## How to use

1. Initializing the system
    ```
    git clone https://github.com/vicalloy/outline-docker-compose.git
    cd outline-docker-compose
    # update config file: vim scripts/config.sh
    make start  # create docker-compose config file and start it.
    make init-uc  # Initializing the oidc-server(add oidc client for outline and create a superuser).
    ```
1. Open `https://192.168.x.x:8888` and login to outline.
1. Open `https://192.168.x.x:8888/uc/admin/auth/user/` to add new user.

### scripts/config.sh

```
# The url used to vist the web site.
# The url should be accessible in host machine and docker container(Can't be localhost or 127.0.0.1).
URL=http://192.168.x.x:8888
# The default interface language. See translate.getoutline.com for a list of
# available language codes and their rough percentage translated.
DEFAULT_LANGUAGE=en_US
# https://docs.djangoproject.com/en/2.2/ref/settings/#language-code
LANGUAGE_CODE=en-us
# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
TIME_ZONE=UTC
FORCE_HTTPS=false

# Nginx
# The nginx bind ip and port.
# If you use ip address to access outline, this ip and port should be same as the URL.
# If this server behind a proxy(nginx), you can bind to `127.0.0.1` .
HTTP_IP=192.168.x.x
HTTP_PORT_IP=8888

# Docker
# If you server behind a proxy(nginx), and the proxy created by docker. You can use the proxy's network. Set the `NETWORKS` to proxy's network name, and set `NETWORKS_EXTERNAL` to `true` .
NETWORKS=outlinewiki
NETWORKS_EXTERNAL=false
```

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
    cp scripts/config.sh.sample scripts/config.sh
    # update config file: vim scripts/config.sh
    make start  # create docker-compose config file and start it.
    make init-uc  # Initializing the oidc-server(add oidc client for outline and create a superuser).
    ```
1. Open `http://127.0.0.1:8888` and login to outline
1. Open `http://127.0.0.1:8888/uc/admin/auth/user/` to add new user

## scripts/config.sh

The config file [scripts/config.sh.sample](scripts/config.sh.sample)

#!/bin/bash
# Generate config and secrets required to host your own outline server
. ./config.sh
. ./utils.sh

MINIO_ACCESS_KEY=`openssl rand -hex 8`
MINIO_SECRET_KEY=`openssl rand -hex 32`

function create_global_env_file {
    fn = .env
    env_file=../$fn
    cp ./templates/$fn $env_file
    env_replace NETWORKS $NETWORKS $env_file
    env_replace NETWORKS_EXTERNAL $NETWORKS_EXTERNAL $env_file
}

function create_nginx_env_file {
    fn=env.nginx
    env_file=../$fn
    cp ./templates/$fn $env_file
    env_replace HTTP_IP $HTTP_IP $env_file
    env_replace HTTP_PORT_IP $HTTP_PORT_IP $env_file
}

function create_minio_env_file {
    fn=env.minio
    env_file=../$fn
    cp ./templates/$fn $env_file
    env_replace MINIO_ACCESS_KEY $MINIO_ACCESS_KEY $env_file
    env_replace MINIO_SECRET_KEY $MINIO_SECRET_KEY $env_file
}

function create_outline_env_file {
    fn=env.outline
    env_file=../$fn
    cp ./templates/$fn $env_file

    SECRET_KEY=`openssl rand -hex 32`
    UTILS_SECRET=`openssl rand -hex 32`

    env_replace URL $URL $env_file
    env_replace SECRET_KEY $SECRET_KEY env.outline
    env_replace UTILS_SECRET $UTILS_SECRET env.outline
    env_replace DEFAULT_LANGUAGE $DEFAULT_LANGUAGE $env_file

    env_delete DATABASE_URL
    env_delete DATABASE_URL_TEST
    env_delete REDIS_URL
    env_delete AWS_S3_UPLOAD_BUCKET_NAME

    env_replace AWS_ACCESS_KEY_ID $MINIO_ACCESS_KEY $env_file
    env_replace AWS_SECRET_ACCESS_KEY $MINIO_SECRET_KEY $env_file
    env_replace AWS_S3_UPLOAD_BUCKET_URL $URL $env_file
}

function create_oidc_env_file {
    fn=env.oidc
    env_file=../$fn
    cp ./templates/$fn $env_file

    env_replace OIDC_CLIENT_ID $OIDC_CLIENT_ID $env_file
    env_replace OIDC_CLIENT_SECRET $OIDC_CLIENT_SECRET $env_file
    env_replace OIDC_AUTH_URI $OIDC_AUTH_URI $env_file
    env_replace OIDC_TOKEN_URI $OIDC_TOKEN_URI $env_file
    env_replace OIDC_USERINFO_URI $OIDC_USERINFO_URI $env_file
}

function create_env_files {
    create_global_env_file
    create_nginx_env_file
    create_minio_env_file
    create_outline_env_file
    create_oidc_env_file
}

function generate {
    cp ./templates/docker-compose.yml ../docker-compose.yml
    create_env_files
}

generate

#!/bin/bash
# Generate config and secrets required to host your own outline server
. ./config.sh
. ./utils.sh

MINIO_ACCESS_KEY=`openssl rand -hex 8`
MINIO_SECRET_KEY=`openssl rand -hex 32`
OIDC_CLIENT_SECRET=`openssl rand -hex 56`
NETWORKS=outlinewiki
NETWORKS_EXTERNAL=false

function create_global_env_file {
    fn=.env
    env_file=../$fn
    cp ./templates/$fn $env_file
    env_replace NETWORKS $NETWORKS $env_file
    env_replace NETWORKS_EXTERNAL $NETWORKS_EXTERNAL $env_file
    # NGINX
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
    env_replace SECRET_KEY $SECRET_KEY $env_file
    env_replace UTILS_SECRET $UTILS_SECRET $env_file
    env_replace DEFAULT_LANGUAGE $DEFAULT_LANGUAGE $env_file
    env_replace FORCE_HTTPS $FORCE_HTTPS $env_file

    env_delete DATABASE_URL $env_file
    env_delete DATABASE_URL_TEST $env_file
    env_delete REDIS_URL $env_file
    env_delete AWS_S3_UPLOAD_BUCKET_NAME $env_file

    env_delete SLACK_KEY $env_file
    env_delete SLACK_SECRET $env_file
    env_delete SLACK_APP_ID $env_file
    env_delete SLACK_KEY $env_file
    env_replace SLACK_MESSAGE_ACTIONS false $env_file

    env_replace AWS_ACCESS_KEY_ID $MINIO_ACCESS_KEY $env_file
    env_replace AWS_SECRET_ACCESS_KEY $MINIO_SECRET_KEY $env_file
    env_replace AWS_S3_UPLOAD_BUCKET_URL $URL $env_file

    env_add PGSSLMODE disable $env_file
}

function create_oidc_env_file {
    fn=env.oidc
    env_file=../$fn
    cp ./templates/$fn $env_file

    env_replace OIDC_CLIENT_SECRET "$OIDC_CLIENT_SECRET" $env_file
    env_replace OIDC_AUTH_URI "${URL}/uc/oauth/authorize/" $env_file
    env_replace OIDC_TOKEN_URI "${URL}/uc/oauth/token/" $env_file
    env_replace OIDC_USERINFO_URI "${URL}/uc/oauth/userinfo/" $env_file
}

function create_uc_env_file {
    fn=env.oidc-server
    env_file=../$fn
    cp ./templates/$fn $env_file

    env_replace LANGUAGE_CODE "$DEFAULT_LANGUAGE" $env_file
    env_replace TIME_ZONE "$TIME_ZONE" $env_file
    DJANGO_SECRET_KEY=`openssl rand -hex 50`
    env_replace SECRET_KEY "$DJANGO_SECRET_KEY" $env_file
}

function create_uc_db_init_file {
    fn=oidc-server-outline-client.json
    file=../config/uc/fixtures/$fn
    cp ./templates/$fn $file

    env_tmpl_replace OIDC_CLIENT_SECRET "$OIDC_CLIENT_SECRET" $file
    env_tmpl_replace URL "$URL" $file
}

function create_env_files {
    create_global_env_file
    create_minio_env_file
    create_outline_env_file
    create_oidc_env_file
    create_uc_env_file
    create_uc_db_init_file
}

function create_docker_compose_file {
    fn=docker-compose.yml
    file=../$fn
    cp ./templates/$fn $file

    env_tmpl_replace NETWORKS "$NETWORKS" $file
}

function init_cfg {
    create_docker_compose_file
    create_env_files
}

$*

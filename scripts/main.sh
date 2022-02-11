#!/bin/bash
# Generate config and secrets required to host your own outline server
. ./config.sh
. ./utils.sh

function create_global_env_file {
    cp ./templates/.env ../
    env_replace NETWORKS ${NETWORKS}
    env_replace NETWORKS_EXTERNAL ${NETWORKS_EXTERNAL}
}

function create_nginx_env_file {
}

create_global_env_file

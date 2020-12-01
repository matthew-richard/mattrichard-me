#!/bin/bash

cd `dirname $BASH_SOURCE`
. ./env

REPO_PATH=`realpath ../..`

# PARSE ARGS #

if [[ "$*" == *--debug* ]]; then
  echo "Running in debug mode."
  ARGS_DEBUG="\
    --env WEBSITE_DEBUG=true \
    -v $REPO_PATH/docker/setup:/root/setup \
    -v $REPO_PATH:/root/repo"
else
  echo "Running in prod mode."
fi

if [[ "$*" == *--detach* ]]; then
  echo "Container will be run in detached mode. Use 'docker logs $WEBSITE_CONTAINER_NAME' to see output."
  ARG_DETACH="-d"
fi

if [[ "$*" == *--keep* ]]; then
  echo "Container will be kept after termination. Use 'docker rm $WEBSITE_CONTAINER_NAME' to delete it."
else
  echo "Container will be removed once terminated. Use --keep to prevent this."
  ARG_RM="--rm"
fi

if [[ "$*" == *--no-data* ]]; then
  echo "Container data will not be persisted in a host volume."
else
  ARGS_DATA="\
    -v $REPO_PATH/docker/data/certbot:/etc/letsencrypt \
    -v $REPO_PATH/docker/data/ssh:/root/.ssh"
fi

if [[ "$*" == *--no-tty* ]]; then
  echo "Not using TTY (Probably being run as a systemd service)."
  ARG_TTY=""
else
  ARG_TTY="-t"
fi

# RUN DOCKER COMMAND #

# Print docker command (prepended by ++) when it's executed
set -o xtrace

docker run \
      --name $WEBSITE_CONTAINER_NAME \
      -i \
      $ARG_TTY \
      -p 443:443 \
      -p 80:80 \
      $ARG_DETACH \
      $ARG_RM \
      --env-file $REPO_PATH/docker/host/env \
      $ARGS_DEBUG \
      $ARGS_DATA \
      $WEBSITE_IMAGE_NAME

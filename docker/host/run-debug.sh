cd `dirname $BASH_SOURCE`
. ./env

REPO_PATH=`realpath ../..`
SETUP_PATH=$REPO_PATH/docker/setup

# Print docker command (prepended by ++) when it's executed
set -o xtrace

docker run \
      --name $WEBSITE_CONTAINER_NAME \
      -it \
      --rm \
      --env-file env \
      --env WEBSITE_DEBUG=true \
      -v $SETUP_PATH:/root/setup \
      -v $REPO_PATH:/root/repo \
      $WEBSITE_IMAGE_NAME

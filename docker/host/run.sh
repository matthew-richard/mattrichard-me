cd `dirname $BASH_SOURCE`
. ./env

REPO_PATH=`realpath ../..`

# Print docker command (prepended by ++) when it's executed
set -o xtrace

docker run \
      --name $WEBSITE_CONTAINER_NAME \
      -it \
      --rm \
      --env-file env \
      $WEBSITE_IMAGE_NAME

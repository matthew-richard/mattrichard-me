cd `dirname $BASH_SOURCE`
. ./env

REPO_PATH=`realpath ../..`
SETUP_PATH=$REPO_PATH/docker/setup

echo "Running $WEBSITE_IMAGE_NAME image in debug mode"
echo "Setting WEBSITE_DEBUG to true"
echo "Attaching repo volume at $REPO_PATH"
echo "Attaching setup files volume (overriding image files) at $SETUP_PATH"
echo "Naming container $WEBSITE_CONTAINER_NAME"
echo

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

# Stop printing commands
set +o xtrace
cd `dirname $BASH_SOURCE`
. ./env

REPO_PATH=`realpath ../..`

echo "Running $WEBSITE_IMAGE_NAME image in debug mode"
echo "Leaving WEBSITE_DEBUG unset"
echo "Naming container $WEBSITE_CONTAINER_NAME"
echo

# Print docker command (prepended by ++) when it's executed
set -o xtrace

docker run \
      --name $WEBSITE_CONTAINER_NAME \
      -it \
      --rm \
      --env-file env \
      $WEBSITE_IMAGE_NAME

# Stop printing commands
set +o xtrace
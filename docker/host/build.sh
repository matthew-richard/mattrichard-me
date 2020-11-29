cd `dirname $BASH_SOURCE`
. ./env

echo "Building docker image $WEBSITE_IMAGE_NAME"
set -o xtrace
docker build -t $WEBSITE_IMAGE_NAME ..
set +o xtrace
echo "Done building docker image $WEBSITE_IMAGE_NAME."
echo "Use run.sh to run the image in prod mode, or run-debug.sh to run the image in debug mode."
cd `dirname $BASH_SOURCE`
. ./env

echo "Building docker image $WEBSITE_IMAGE_NAME"
docker build -t $WEBSITE_IMAGE_NAME ..
echo "Done building docker image $WEBSITE_IMAGE_NAME."
echo "Use run.sh to run the image in prod mode, or run-debug.sh to run the image in debug mode."
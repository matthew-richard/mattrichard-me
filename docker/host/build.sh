cd `dirname $BASH_SOURCE`
. ./env

echo "Building docker image $WEBSITE_IMAGE_NAME"
docker build -t $WEBSITE_IMAGE_NAME ..
echo "Done building docker image $WEBSITE_IMAGE_NAME. Use run.sh to run it in debug mode"
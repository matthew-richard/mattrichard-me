cd `dirname $BASH_SOURCE`
. ./env

# Print docker command (prepended by ++) when it's executed
set -o xtrace

# Print setup.sh output with timestamps
docker logs -t $WEBSITE_CONTAINER_NAME
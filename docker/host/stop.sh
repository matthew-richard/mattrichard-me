cd `dirname $BASH_SOURCE`
. ./env

# Print docker command (prepended by ++) when it's executed
set -o xtrace

docker stop $WEBSITE_CONTAINER_NAME
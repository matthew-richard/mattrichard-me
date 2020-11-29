cd `dirname $BASH_SOURCE`
. ./env

# Print docker command (prepended by ++) when it's executed
set -o xtrace

docker exec -it $WEBSITE_CONTAINER_NAME tmux attach

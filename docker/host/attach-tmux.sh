cd `dirname $BASH_SOURCE`
. ./env

echo "Executing 'tmux attach' on the $WEBSITE_CONTAINER_NAME container."

# Print docker command (prepended by ++) when it's executed
set -o xtrace

docker exec -it $WEBSITE_CONTAINER_NAME tmux attach

# Stop printing commands
set +o xtrace
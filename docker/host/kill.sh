#!/bin/bash

cd `dirname $BASH_SOURCE`
. ./env

# Print docker command (prepended by ++) when it's executed
set -o xtrace

docker kill $WEBSITE_CONTAINER_NAME
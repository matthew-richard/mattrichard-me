#!/bin/bash

# Creates startup service on distros that init with systemd.
# This has only been tested on Ubuntu 18.04 LTS.

if [ "$USER" != "root" ]; then
  echo "Please run this script as root. Exiting."
  exit
fi

cd `dirname $BASH_SOURCE`
. ./env

REPO_PATH=`realpath ../..`

SERVICE_DEF_PATH=/etc/systemd/system/$WEBSITE_IMAGE_NAME.service
echo "Writing service definition to $SERVICE_DEF_PATH"
cat website.service.template | \
  sed "s|WEBSITE_IMAGE_NAME|$WEBSITE_IMAGE_NAME|g" | \
  sed "s|REPO_PATH|$REPO_PATH|g" \
  > $SERVICE_DEF_PATH

echo
echo "Service contents:"
cat $SERVICE_DEF_PATH
echo

echo "Starting service."
systemctl daemon-reload
systemctl start $WEBSITE_IMAGE_NAME
echo

echo "Enabling service to run on startup."
systemctl enable $WEBSITE_IMAGE_NAME
echo

echo
echo "Done installing systemd service."
echo "Check status with 'systemctl status $WEBSITE_IMAGE_NAME'."
echo "Check logs with 'journalctl -u $WEBSITE_IMAGE_NAME'"
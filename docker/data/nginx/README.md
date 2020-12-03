# Nginx Config Directory #

This folder will be passed to the docker container as its `/etc/nginx/conf.d` directory.

The `app.conf` file contains the Nginx configuration for the site, which redirects HTTP to HTTPS, and passes all requests to the NodeJS app running on a non-default port.
# Certbot Config Directory #

This folder will be passed to the Docker container as its `/etc/letsencrypt` directory.

`cli.ini` is an out-of-the-box config file created by Certbot upon installation and does not need to be modified.

There is no need to modify this folder manually. It will be populated during the first run of the container. After the first run, assuming the certificate generation process succeeds, there will be additional config files added, including the certificate files `fullchain.pem` and `privkey.pem` under `live/<domain>/`.
# SSH Config Directory #

This folder will be passed to the docker container as its `/root/.ssh` directory.

In order for the repo cloning process in setup.sh to succeed, you must supply an SSH key with access to the repo being cloned. This means adding two files: the private key `id_rsa`, and the public key `id_rsa.pub`.


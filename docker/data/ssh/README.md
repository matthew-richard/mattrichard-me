# SSH Config Directory #

This folder will be passed to the docker container as its `/root/.ssh` directory.

The `known_hosts` file contains fingerprints for `github.com`, so that the repo cloning process doesn't prompt for fingerprints.

In order for the repo cloning process in setup.sh to succeed, you must supply an SSH key with access to the repo being cloned. This means adding two files: the private key `id_rsa`, and the public key `id_rsa.pub` (`rsa` may be replaced by something different depending on the algorithm you use to generate the key, e.g. `id_ed25519`.).

For deploying to prod, it's best to generate a [Github deploy key](https://docs.github.com/en/free-pro-team@latest/developers/overview/managing-deploy-keys#deploy-keys), which has access to just the one repository.


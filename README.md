# mattrichard-me

Resume site based on the SpirIT template from https://themeforest.net/item/spirit-portfolioresume-html-template-for-developers-programmers-and-freelancers/17094383

https://medium.com/@pentacent/nginx-and-lets-encrypt-with-docker-in-less-than-5-minutes-b4b8a60d3a71

# Installation Instructions #

Regardless of whether you plan to run this site in debug mode or prod mode, you must do the following:

* Install Docker https://docs.docker.com/engine/install.
* Build the Docker image for this site by running `docker/host/build.sh` (If on Windows, install [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10))
* Populate `docker/host/env` with your own domain details.

## Running in Debug Mode ##

To run this website on your own machine in debug mode:

* Run `docker/data/run.sh --debug`, which will start the Docker container created by `build.sh`
*

## Running in Prod Mode ##

To run this website on a machine in prod mode:

* Populate `docker/data/ssh` with SSH keys that can clone this repo. (More instructions are in the README of that directory)
* *

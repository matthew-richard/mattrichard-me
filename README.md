# mattrichard-me

This is the source for my personal website [mattrichard.me](https://mattrichard.me).

The site's theme is originally based on the [SpirIT template from themeforest.net](https://themeforest.net/item/spirit-portfolioresume-html-template-for-developers-programmers-and-freelancers/17094383).

The site uses [Docker](https://www.docker.com/) to provide a consistent, virtualized development environment across the test instance on my home machine and the prod instance I have deployed to an [AWS EC2](https://aws.amazon.com/ec2) instance.

The site automatically stands up an environment in [tmux](https://github.com/tmux/tmux/wiki), a terminal multiplexer, to provide a barebones, terminal-based server monitoring UI, as well as to generate a convenient development environment on my home machine when the site is run in debug mode.

https://medium.com/@pentacent/nginx-and-lets-encrypt-with-docker-in-less-than-5-minutes-b4b8a60d3a71

### A Note On Virtualization ###

I'd hesitate to say this site is "containerized", since it doesn't follow the Docker convention of keeping about one process per container. Instead, I install a bunch of packages to one Ubuntu 18.04 LTS image and effectively treat it as my own little virtual machine. In some sense I'm using Docker in the way [Vagrant](https://www.vagrantup.com/) is intended to be used.

There are some limitations to this approach compared to a full fledged virtual machine, namely that [you can't make systemd services in Docker containers](https://stackoverflow.com/questions/60928901/systemctl-command-doesnt-work-inside-docker-container), but for the most part I'm quite satisfied with it.

So, though the site isn't quite containerized, it's certainly virtualized.

# Two Ways to Run #

Want to deploy a version of this site yourself? There are two main ways you can run the Docker image - prod mode and debug mode.

## Prod Mode ##

Prod mode is for when you've already got DNS for your domain setup to point to the box running the Docker image.

When you start in prod mode, the image automatically tries to grab an SSL certificate using certbot. It also clones the repo and constantly monitors it for updates, serving new content within seconds of you pushing it to the repo.

## Debug Mode ##

Debug mode is for when you're testing and modifying the site on a dev machine. It's probably what you'll run first.

Debug mode uses self-signed SSL certificates, and instead of constantly monitoring the repo, it attaches a volume to the docker image so that you can modify files locally and see the results in real time.

If you provide AWS credentials, debug mode can also provide convenient shortcuts for stopping, starting, and monitoring the EC2 instances that are running the site in prod mode.

# Setup #

Regardless of whether you plan to run this site in debug mode or prod mode, you must do the following:

* Install Docker https://docs.docker.com/engine/install.
* Build the Docker image for this site by running `docker/host/build.sh` (If on Windows, install [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10))
* Populate `docker/host/env` with your own domain details.

## Running in Debug Mode ##

To run this website on your own machine in debug mode:

* Run `docker/data/run.sh --debug`, which will start the Docker container created by `build.sh`

## Running in Prod Mode ##

To run this website on a machine in prod mode:

* Fork this repo. Modify `docker/host/env` to point to the new repo URL.
* Generate SSH keys with access to the forked repo, and populate `docker/data/ssh` with them. (More instructions are in README.md of `docker/data/ssh`)
* Ensure that you've configured DNS to resolve to the domain you specified in `docker/host/env` (e.g. mattrichard.me). Otherwise, the Docker image will fail to acquire an SSL certificate via [certbot](https://certbot.eff.org/) and the setup process will terminate.

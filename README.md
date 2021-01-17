# mattrichard.me 🧑‍💻 #

This is the source for my personal website [mattrichard.me](https://mattrichard.me), which is one part resume, two parts playground for web development.

The site's theme is originally based on the [SpirIT template from themeforest.net](https://themeforest.net/item/spirit-portfolioresume-html-template-for-developers-programmers-and-freelancers/17094383).

The core logic of the site (located in `app/`) is a [NodeJS](https://nodejs.org/en/) app that uses the minimalist [express](https://expressjs.com/) web framework. [Nginx](https://www.nginx.com/) takes care of the boring stuff, e.g. redirecting plain old HTTP to HTTPS, before passing control the the NodeJS app by [acting as a reverse proxy](https://www.sitepoint.com/configuring-nginx-ssl-node-js/).

The site uses a [Docker](https://www.docker.com/) image (defined in `docker/`) to provide a consistent, virtualized, Ubuntu-based development environment across the test instances on my home machine and the prod instance I have deployed to an [AWS EC2](https://aws.amazon.com/ec2) virtual machine.

The Docker image stands up a session in [tmux](https://github.com/tmux/tmux/wiki), a terminal multiplexer, to provide a barebones, console-based server monitoring UI, as well as to generate a convenient development environment for my home machine when the site is run in debug mode.


# File Structure #

```
app/ - The NodeJS app.
  index.html - Front page HTML
  app.js - NodeJS app core logic
  gulfile.js - Gulp tasks
  assets/ - Site assets e.g. fonts, images, javascript, documents, CSS.
    css/ - CSS rendered from Sass files in scss/
    scss/ - Sass files for generating CSS
      base/scaffolding.scss - Currently using this as a catch-all file for global CSS rules
      components/ - Styling for individual page sections
      settings/variables.scss - Variables referenced in other Sass files, e.g. main theme colors
      vendor/ - Third-party SCSS. Do not modify.
      main.scss - Parent SCSS file that includes all others. Compiled to assets/css/main.css.
    js/ - JavaScript files
      menu.js and mobile-menu.js - Logic for nav menu
      section.js - Logic for animating header text
      show-details.js - Logic for hiding/showing .unnecessary-detail elements based on URL
  blog/ - Text for future blog posts

docker/ - The docker image definition.
  Dockerfile - File used to generate the docker image with the "docker build" command (see setup/build.sh).
  setup/ - Setup scripts to be run by the Docker image.
  host/ - Util scripts and files for running the Docker image on the host.
  data/ - Directories used as volumes by scripts in host/, capturing persisted output from the Docker image.
```

# Two Ways to Run #

Want to deploy a version of this site yourself? There are two main ways you can run the Docker image - prod mode and debug mode.

## Prod Mode ##

Prod mode is for when you've already got DNS for your domain setup to point to the box running the Docker image.

When you start in prod mode, the image automatically tries to grab an SSL certificate using certbot. It also clones the repo and constantly monitors it for updates, serving new content within seconds of you pushing it to the repo.

## Debug Mode ##

Debug mode is for when you're testing and modifying the site on a dev machine. It's probably what you'll run first.

Debug mode uses self-signed SSL certificates, and instead of constantly monitoring the repo, it attaches a volume to the docker image so that you can modify files locally and see the results in real time, without the ceremony or commitment of pushing to the repo.

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
* Run `docker/data/run.sh`, which will start the Docker container created by `build.sh`
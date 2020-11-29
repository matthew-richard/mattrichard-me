FROM ubuntu:18.04

# Set up apt packages
RUN apt update
RUN apt upgrade

# Install core dependencies
# Use noninteractive frontend to avoid installation prompts from certbot
RUN DEBIAN_FRONTEND=noninteractive \
  apt install -y \
    tmux=2.6-3ubuntu0.2 \
    nodejs=8.10.0~dfsg-2ubuntu0.4 \
    npm=3.5.2-0ubuntu4 \
    nginx=1.14.0-0ubuntu1.7 \
    certbot=0.27.0-1~ubuntu18.04.2 \
    git

# Install utilities
RUN apt install -y \
  curl \
  nano

# Set up npm packages
RUN npm install --global \
  gulp-cli@2.3.0 \
  http-server@0.12.3

COPY setup /root/setup
RUN mkdir /root/repo

# Add bash customizations
RUN echo "\n. /root/setup/bashrc-customizations.sh" >> /root/.bashrc
RUN echo "\n. /root/setup/bashprofile-customizations.sh" >> /root/.profile

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/root/setup/setup.sh"]

#!/bin/bash

## FUNCTIONS ##

# Check env variable to see if running in debug mode
is-debug () {
  test ! -z "$WEBSITE_DEBUG"
}

# Function to run command $2 in a tmux window named $1.
run-in-tmux () {
  echo "Running command '$2' in tmux window named '$1'"

  # Open window (or use existing unassigned one)
  if [ -z "$TMUX_FIRST_WINDOW_ASSIGNED" ]; then
    tmux rename-window -t server:0 "$1"
    TMUX_FIRST_WINDOW_ASSIGNED=true
  else
    tmux new-window -n "$1"
  fi

  # Wait for window to initialize
  sleep 0.5s

  # Send command to window (C-m is enter keystroke)
  tmux send-keys -t $TMUX_SESSION_NAME:$1 "$2" C-m
}

## SCRIPT ##

echo
echo "*** Beginning dockerized website setup. ***"
echo

# Print relevant environment info
echo "Environment:"
env | grep -P '^WEBSITE.*' | sed 's/^/  /'
echo
if ! is-debug ; then echo "In prod mode."; else echo "In debug mode."; fi
echo

# Init tmux
TMUX_SESSION_NAME=server
echo "Starting tmux session named '$TMUX_SESSION_NAME'."
tmux new-session -d -s $TMUX_SESSION_NAME
echo

# Certificate setup
if ! is-debug ; then
  echo "Setting up SSL certificate in prod mode."

  if ! [ -e /etc/letsencrypt/live/$WEBSITE_DOMAIN/fullchain.pem -a \
         -e /etc/letsencrypt/live/$WEBSITE_DOMAIN/privkey.pem ]; then

    echo "Did not find fullchain.pem and privkey.pem in /etc/letsencrypt/live/$WEBSITE_DOMAIN. Requesting certificate via certbot."

    certbot certonly --agree-tos --noninteractive --standalone -d $WEBSITE_DOMAIN -m $WEBSITE_CERTBOT_EMAIL

    if ! [ -e /etc/letsencrypt/live/$WEBSITE_DOMAIN/fullchain.pem -a \
           -e /etc/letsencrypt/live/$WEBSITE_DOMAIN/privkey.pem ]; then
      echo "*** Certificate acquisition failed. Aborting setup. ***"
      exit
    fi
  fi

  # Start certificate renewal loop in tmux window.
  echo "Starting certificate renewal loop in tmux window."
  run-in-tmux cert-renew 'while true; do sleep 12h; echo "$(date): Attempting certificate renewal."; certbot renew; done'

  # LATER (When nginx added):
    # Create symlinks to /root/cert/fullchain.pem and /root/cert/privkey.pem
    # Add nginx reload command to certificate renewal loop

else
  echo "Setting up certificate in debug mode."
  echo "Nothing necessary to set up certificate in debug mode for now."

  # LATER (When nginx added):
    # Generate self-signed certificate
    # Symlink (if necessary) to /root/cert/fullchain.pem and /root/cert/privkey.pem
fi
echo

# Repo setup
if ! is-debug ; then
  echo "Setting up repo in prod mode."

  echo "Cloning repo."
  if ! { git clone $WEBSITE_REPO /root/repo ; }; then
    echo "*** Repo cloning failed. Aborting setup. ***"
    exit
  fi

  echo "Checking out branch origin/$WEBSITE_REPO_BRANCH"
  if ! { cd /root/repo && git checkout origin/$WEBSITE_REPO_BRANCH ; }; then
    echo "*** Repo branch checkout failed. Aborting setup. ***"
    exit
  fi

  echo "Running npm install in repo."
  if ! { cd /root/repo/app && npm install ; }; then
    echo "*** Package installation failed. Aborting setup. ***"
    exit
  fi

else
  echo "Setting up repo in debug mode."

  if ! { cd /root/repo/app ; }; then
    echo "*** Failed to cd into /root/repo/app. The repo should already be attached as a volume in debug mode. Aborting setup. ***"
    exit
  fi

  if [ -e node_modules ]; then
    echo "Found /root/repo/app/node_modules, so skipping 'npm install' to avoid npm-shrinkwrap issues."
  else
    echo "Did not find /root/repo/app/node_modules, so running 'npm install'."
    npm install
  fi
fi
echo

# Setup repo watch
echo "Running gulp watch in tmux window."
run-in-tmux watch 'cd /root/repo/app && gulp watch'
echo

# Setup repo mirroring
if ! is-debug ; then
  echo "Mirroring repo in prod mode."
  run-in-tmux mirror "cd /root/repo && while true; do echo -n \"\$(date): \"; git fetch; git checkout origin/$WEBSITE_REPO_BRANCH; sleep 10; done"
fi
echo

# Setup serve command
if ! is-debug ; then
  echo "Serving files in prod mode."
  run-in-tmux serve 'cd /root/repo/app && gulp serve-prod'
else
  echo "Serving files in debug mode."
  run-in-tmux serve 'cd /root/repo/app && gulp serve-dev'
fi
echo

# Select 'serve' window
tmux select-window -t $TMUX_SESSION_NAME:serve

echo "*** Dockerized website setup complete. ***"
echo

echo "INSTRUCTIONS:"
echo
echo "To monitor the server, start a shell in this container (with docker exec or SSH) and run 'tmux attach'. Alternatively use attach.sh, if this container was run using run.sh."
echo
echo "If you're currently attached to this container, you can detach (without killing the container) using Ctrl+P Ctrl+Q."
echo

# Wait indefinitely so the container doesn't get terminated
echo
echo "This script will now run an infinite loop to keep its process alive."
echo
while true; do
  sleep 10
done

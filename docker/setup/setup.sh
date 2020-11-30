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

  # Check if cert is already present at /etc/letsencrypt/live/mattrichard.me/fullchain.pem
  # If not present, run
  # certbot certonly --standalone -d $WEBSITE_DOMAIN -m $WEBSITE_CERTBOT_EMAIL

  # Verify certificate is now present.

  # Create symlinks to /root/cert/fullchain.pem and /root/cert/privkey.pem

  # Start certificate renewal loop in tmux window.
  echo "Starting certificate renewal loop in tmux window."
  run-in-tmux cert-renew 'echo "Renewing certificate."'

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

  # Verify SSH key exists at /root/.ssh/id_rsa

  # Verify that repo not already at /root/repo ("Did you attach a volume?")

  # Clone repo to /root/repo
  # git clone $WEBSITE_REPO /root/repo

  # Verify that repo files exist

  # Run npm install on /root/repo/app
else
  echo "Setting up repo in debug mode."
  # Verify repo already present at /root/repo ("Did you remember to attach a volume there?")

  # ONLY IF /root/repo/app/node_modules DOESN'T ALREADY EXIST (since otherwise there could be problems
  # with npm-shrinkwrap)...
  # Run npm install on /root/repo/app
fi
echo

# Setup repo watch
echo "Running gulp watch in tmux window."
run-in-tmux watch 'echo "Watching repo."'
# Run gulp watch in tmux window
echo

# Setup repo mirroring
if ! is-debug ; then
  echo "Mirroring repo in prod mode."
  run-in-tmux mirror 'echo "Mirroring repo."'
fi
echo

# Setup serve command
if ! is-debug ; then
  echo "Serving files in prod mode."
  run-in-tmux serve 'echo "Serving in prod"'
  # Run gulp serve-prod in tmux window
else
  echo "Serving files in debug mode."
  run-in-tmux serve 'echo "Serving in debug mode"'
  # Run gulp serve-dev in tmux window
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

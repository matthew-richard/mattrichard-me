# Init tmux session

# Certificate setup
if [ ! -z "$WEBSITE_DEBUG" ]; then

  # Check if cert is already present at /etc/letsencrypt/live/mattrichard.me/fullchain.pem
  # If not present, run
  # certbot certonly --standalone -d $WEBSITE_DOMAIN -m $WEBSITE_CERTBOT_EMAIL

  # Verify certificate is now present.

  # Create symlinks to /root/cert/fullchain.pem and /root/cert/privkey.pem

  # Start certificate renewal loop in tmux window.

  # LATER (When nginx added):
    # Create symlinks to /root/cert/fullchain.pem and /root/cert/privkey.pem
    # Add nginx reload command to certificate renewal loop


else
  # LATER (When nginx added):
    # Generate self-signed certificate
    # Symlink (if necessary) to /root/cert/fullchain.pem and /root/cert/privkey.pem
fi

# Repo setup
if [ ! -z "$WEBSITE_DEBUG" ]; then

  # Verify SSH key exists at /root/.ssh/id_rsa

  # Verify that repo not already at /root/repo ("Did you attach a volume?")

  # Clone repo to /root/repo
  # git clone $WEBSITE_REPO /root/repo

  # Verify that repo files exist

  # Run npm install on /root/repo/app
else
  # Verify repo already present at /root/repo ("Did you remember to attach a volume there?")

  # ONLY IF /root/repo/app/node_modules DOESN'T ALREADY EXIST (since otherwise there could be problems
  # with npm-shrinkwrap)...
  # Run npm install on /root/repo/app
fi

# Setup repo watch
# Run gulp watch in tmux window

# Setup repo mirroring
if [ ! -z "$WEBSITE_DEBUG" ]; then
  # Run repo mirroring loop in tmux window
else

# Setup serve command
if [ ! -z "$WEBSITE_DEBUG" ]; then
  # Run gulp serve-prod in tmux window
else
  # Run gulp serve-dev in tmux window
fi

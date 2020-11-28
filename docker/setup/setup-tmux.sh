#!/bin/bash

cd ~;

# Start session
tmux new-session -d -s "server"

# Set up layout
tmux rename-window -t server:0 serve
tmux new-window -n watch
tmux new-window -n pull
tmux new-window -n setup

# Initialize panes
sleep 0.5
tmux send-keys -t server:serve "cd /repo/app; sudo gulp serve-prod" C-m
tmux send-keys -t server:watch "cd /repo/app; sudo gulp watch" C-m
tmux send-keys -t server:pull 'cd /repo; while true; do echo -n "$(date):"; git fetch; git checkout origin/master; sleep 10; done' C-m


tmux select-window -t server:serve

# Open session after initializing?
SILENT=false
for arg in "$@"
do
  if [ $arg == "-s" ]
  then
    SILENT=true
    break
  fi
done

if [ "$SILENT" == false ]
then
  tmux attach -t server
fi

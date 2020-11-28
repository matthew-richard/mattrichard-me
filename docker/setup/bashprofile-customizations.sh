# Attach to running tmux session on login
# (provided we're not already in a tmux session)
if [ -z "$TMUX" ]; then
  tmux attach
fi
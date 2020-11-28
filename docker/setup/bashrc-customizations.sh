# Save bash history immediately
export PROMPT_COMMAND="history -a"
shopt -s histappend

# Set large bash_history history size
HISTSIZE=20000
HISTFILESIZE=20000

# Hide ugly green backgrounds on NTFS folders
LS_COLORS="ow=01;36;40" && export LS_COLORS

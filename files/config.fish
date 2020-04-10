# Set up virtualfish
eval (python3 -m virtualfish auto_activation)

# Add $HOME/.local/bin
set PATH $HOME/.local/bin $PATH

# Set up arrow keys for history completion
bind -k up history-token-search-backward
bind -k down history-token-search-forward

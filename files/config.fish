# Add $HOME/.local/bin to path
set PATH $HOME/.local/bin $HOME/go/bin $PATH

# Set vim as editor
if which vim 2>&1 > /dev/null
    set EDITOR (which vim)
end

# Set up arrow keys for history completion
bind -k up history-token-search-backward
bind -k down history-token-search-forward

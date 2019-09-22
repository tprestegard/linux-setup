# Defined in /tmp/fish.ke9WC0/fish_prompt.fish @ line 2
function fish_prompt --description 'Write out the prompt'
	if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    if not set -q __fish_prompt_cwd
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end

    # Add virtual environment information
    if set -q VIRTUAL_ENV
        echo -n -s (set_color -b FFFFFF -o 2E37FE) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
    end

    echo -n -s "$USER" @ (prompt_hostname) ' ' "$__fish_prompt_cwd" (prompt_pwd) (__fish_vcs_prompt) "$__fish_prompt_normal" '> '
end

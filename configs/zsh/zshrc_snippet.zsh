# -----------------------------------------------------------------------------
# BlackIce Suite — Shell Enhancements & Modern CLI Toolchain
# -----------------------------------------------------------------------------

# System stats banner on interactive startup
if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi

# Modern CLI replacements
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons'
    alias ll='eza -la --icons --git'
    alias lt='eza --tree --level=2 --icons'
fi

if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never --style=plain'
fi

# Handy network & pentest aliases
alias ports='ss -tulpn'
alias myip='curl -s https://ifconfig.me && echo'

# Initialize Starship Prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

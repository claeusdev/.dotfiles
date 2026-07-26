# ======================
# PATH Configuration
# ======================
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# GHC/Haskell
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
set -gx PATH $HOME/.cabal/bin $HOME/.ghcup/bin $PATH

# ======================
# Shell Integrations
# ======================

# Zoxide - smart directory jumper
if command -v zoxide &> /dev/null
    zoxide init fish | source
end

# fnm (Fast Node Manager)
if command -v fnm &> /dev/null
    fnm env --use-on-cd --shell fish | source
end

# fnm's per-shell multishell dir is ephemeral, so long-running apps that
# inherit PATH once at launch (Emacs via exec-path-from-shell) can end up
# pointing at a node that no longer exists. Append the stable default alias
# as a lower-priority fallback; per-project versions still take precedence.
if test -d "$HOME/.local/share/fnm/aliases/default/bin"
    set -gx PATH $PATH "$HOME/.local/share/fnm/aliases/default/bin"
end

# ======================
# Modern CLI Tool Aliases
# ======================

# eza (modern ls)
if command -v eza &> /dev/null
    alias ls='eza --icons'
    alias ll='eza -l --icons'
    alias la='eza -la --icons'
    alias lt='eza --tree --icons'
    alias tree='eza --tree --icons'
end

# bat (cat with syntax highlighting)
if command -v bat &> /dev/null
    alias cat='bat'
else if command -v batcat &> /dev/null
    alias cat='batcat'
    alias bat='batcat'
end

# fd (modern find)
if command -v fdfind &> /dev/null
    alias fd='fdfind'
end

# ripgrep
if command -v rg &> /dev/null
    alias grep='rg'
end

# ======================
# Git Alias
# ======================
alias g='git'

# ======================
# Navigation Aliases
# ======================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias wks='cd ~/workspace'
alias work='wks && cd work'

# ======================
# Utility Aliases
# ======================
alias c='clear'
alias h='history'
alias vim='nvim'
alias v='nvim'

# ======================
# ML/AI & Scientific Tools
# ======================
alias jl='jupyter lab'
alias nb='jupyter notebook'
alias tb='tensorboard --logdir'

# ======================
# Atuin (shell history)
# ======================
if command -q atuin
    atuin init fish | source
end

# ======================
# Language/Runtime Configs
# ======================

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
test -r "$HOME/.opam/opam-init/init.fish" && source "$HOME/.opam/opam-init/init.fish" > /dev/null 2> /dev/null; or true
# END opam configuration

# ======================
# Platform-specific paths
# ======================
switch (uname)
    case Darwin
        # Antigravity (macOS only)
        test -d "$HOME/.antigravity/antigravity/bin" && fish_add_path "$HOME/.antigravity/antigravity/bin"
        # Coursier (Scala) - macOS location
        test -d "$HOME/Library/Application Support/Coursier/bin" && set -gx PATH "$PATH:$HOME/Library/Application Support/Coursier/bin"
    case Linux
        # Coursier (Scala) - Linux location
        test -d "$HOME/.local/share/coursier/bin" && set -gx PATH "$PATH:$HOME/.local/share/coursier/bin"
end

# mise (version manager)
if command -q mise
    mise activate fish | source
end

# Starship prompt
if command -q starship
    starship init fish | source
end

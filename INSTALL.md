# Installation Guide

## One-Command Setup

```sh
bash <(curl -s https://raw.githubusercontent.com/naamanu/.dotfiles/main/setup.sh)
```

This single command will:

1. **Install chezmoi** (dotfile manager)
2. **Clone and deploy dotfiles** via SSH
3. **Install development tools** (platform-appropriate)
4. **Post-install setup**: TPM (tmux plugin manager), set fish as default shell

The script is idempotent — safe to re-run on an already-configured machine.

## What's Managed by Chezmoi

Chezmoi manages all configuration files. The setup script only installs packages — it never writes config files.

| Config | Source path in chezmoi |
| :--- | :--- |
| fish shell | `dot_config/fish/` |
| ghostty | `dot_config/ghostty/` |
| starship | `dot_config/starship.toml` |
| neovim | `dot_config/nvim/` |
| tmux | `dot_tmux.conf` |
| git | `dot_gitconfig` |
| emacs | `dot_emacs.d/` |

To edit a config: `chezmoi edit ~/.config/fish/config.fish --apply`

## What Gets Installed

### Both Platforms
- Core: build tools, git, curl, wget, cmake
- Shell: fish, tmux, starship, zoxide
- CLI: neovim, ripgrep, fd, fzf, bat, eza, jq, btop
- Languages: Node.js, Python, Rust, Go, Lua
- FP/Research: OCaml, SML, Lisp, Racket, Coq, Agda
- LSP/Formatters: language servers, prettier, stylua, shellcheck
- Git: gh, lazygit, git-delta
- Databases: PostgreSQL, SQLite
- Containers: Docker, lazydocker
- Fonts: JetBrains Mono, Inconsolata (Nerd Font patched)

### macOS Only
- Homebrew (installed automatically)
- Cloud/DevOps: awscli, terraform, kubectl, k9s
- Apps: Rectangle, Ghostty (cask), Raycast

## Post-Install Checklist

- [ ] Restart terminal (or log out/in)
- [ ] `nvim '+Lazy sync' +qa` — install Neovim plugins
- [ ] Open tmux, press `prefix + I` — install tmux plugins
- [ ] Log out/in for Docker group changes (Linux)
- [ ] `gh auth login` — authenticate GitHub CLI

## Troubleshooting

### macOS: Command not found after installation
```sh
source ~/.zprofile
```

### Linux: Docker permission denied
Log out and back in, then:
```sh
docker run hello-world
```

### Neovim: Plugins not loading
```sh
nvim '+Lazy clean' '+Lazy sync'
```

## Updating

Pull the latest dotfiles and re-apply:
```sh
chezmoi update
```

Update installed packages:
```sh
# macOS
brew update && brew upgrade

# Ubuntu/Debian
sudo apt update && sudo apt upgrade

# Fedora
sudo dnf upgrade

# Arch
sudo pacman -Syu
```

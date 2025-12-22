# Installation Guide

This directory contains scripts to set up your development environment.

## Quick Start

### 1. Clone and Set Up Dotfiles

```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

This will:
- Create symlinks for your dotfiles (tmux, git, nvim, fish, ghostty, starship, emacs)
- Initialize git submodules
- Back up any existing configs to `~/.dotfiles_old/`

### 2. Install Development Tools

Choose the script for your operating system:

#### macOS
```bash
./install-tools-mac.sh
```

#### Linux (Ubuntu/Debian/Fedora/Arch)
```bash
./install-tools-linux.sh
```

## What Gets Installed

### Core Development Tools
- **Build tools**: gcc, make, cmake
- **Version control**: git, gh (GitHub CLI), lazygit
- **Package managers**: Homebrew (macOS), nvm (Node.js)

### Shell & Terminal
- **ghostty**: Modern GPU-accelerated terminal emulator
- **fish**: Modern, user-friendly shell with excellent autocompletion
- **tmux**: Terminal multiplexer for session management
- **starship**: Beautiful, fast, and customizable cross-shell prompt
- **zoxide**: Smart directory navigation (cd replacement)

### Modern CLI Utilities
- **neovim**: Hyperextensible Vim-based text editor
- **ripgrep** (`rg`): Extremely fast grep alternative
- **fd**: Fast and user-friendly find alternative
- **fzf**: Command-line fuzzy finder
- **bat**: Cat clone with syntax highlighting
- **eza**: Modern ls replacement with colors and icons
- **btop**: Beautiful process/system monitor
- **jq**: JSON processor
- **yq**: YAML processor
- **tree**: Directory tree viewer
- **lazydocker**: Terminal UI for Docker

### Programming Languages
- **Node.js**: JavaScript runtime (via nvm)
- **Python 3**: Python programming language
- **Rust**: Systems programming language
- **Go**: Google's programming language
- **Lua**: Lightweight scripting language

### Language Servers & Formatters
- **LSP servers**: TypeScript, Python (Pyright), Rust, Go, Lua
- **Formatters**: Prettier, Black, Stylua, shfmt
- **Linters**: ESLint, Ruff, ShellCheck

### Databases
- **PostgreSQL**: Advanced relational database
- **SQLite**: Lightweight embedded database
- **Redis**: In-memory data store (macOS only)

### Container & Cloud Tools
- **Docker**: Container platform
- **lazydocker**: Docker terminal UI
- **kubectl**: Kubernetes CLI (macOS)
- **k9s**: Kubernetes terminal UI (macOS)
- **terraform**: Infrastructure as code (macOS)
- **AWS CLI**: Amazon Web Services CLI (macOS)

### Fonts
- **JetBrains Mono Nerd Font**: Programming font with icons
- **Fira Code Nerd Font**: Programming font with ligatures (macOS)
- **Hack Nerd Font**: Programming font (macOS)

### macOS Specific
- **Rectangle**: Window management
- **Raycast**: Spotlight replacement with plugins

## Post-Installation

### 1. Launch Ghostty
The installation scripts automatically configure Ghostty with:
- Inconsolata Nerd Font
- Fish shell integration
- Dark theme with transparency
- Useful keybindings

Just launch Ghostty and you're ready to go!

### 2. Verify Fish Shell Configuration
Open a new terminal and verify modern tools are working:
```bash
# Test eza (modern ls)
ls

# Test bat (cat with syntax highlighting)
cat ~/.config/fish/config.fish

# Test zoxide (smart cd)
z ~  # or just 'cd' somewhere, then 'z' to jump back

# Test starship prompt
# You should see a beautiful prompt with git info, language versions, etc.
```

### 3. Configure Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 4. Set Fish as Default Shell
```bash
# macOS
chsh -s /opt/homebrew/bin/fish

# Linux
chsh -s $(which fish)
```

### 5. Install Neovim Plugins
```bash
nvim +Lazy sync +qa
```

### 6. Restart Terminal
Log out and back in, or open a new terminal window (or use Ghostty!) to apply all changes.

### 7. Docker Setup (Linux)
After installation, log out and back in for Docker group permissions to take effect.

## Using Modern CLI Tools

The installation configures your shell with aliases for modern replacements of classic Unix tools:

### File Listing (eza)
```bash
ls          # List files with icons
ll          # Long format with details
la          # List all files including hidden
lt          # Tree view
tree        # Also aliased to eza --tree
```

### File Viewing (bat)
```bash
cat file.txt           # View file with syntax highlighting
bat file.txt           # Same thing
bat --style=plain      # Plain output without decorations
```

### File Finding (fd & ripgrep)
```bash
fd pattern              # Find files/directories
fd "\.js$"              # Find all .js files
rg "search term"        # Search file contents (replaces grep)
rg -i "case insensitive" # Case-insensitive search
```

### Smart Navigation (zoxide)
```bash
z workspace            # Jump to most-used directory matching "workspace"
z proj work            # Jump to directory matching "proj" and "work"
zi                     # Interactive directory picker
```

After using `cd` to navigate a few times, zoxide learns your patterns and `z` becomes very powerful!

### Git Shortcuts
The fish config includes many git aliases:
```bash
g          # git
gs         # git status
ga         # git add
gc         # git commit
gcm        # git commit -m "message"
gp         # git push
gl         # git pull
glog       # Pretty git log with graph
gd         # git diff
gco        # git checkout
gb         # git branch
```

### Lazygit & Lazydocker
```bash
lazygit    # Terminal UI for git
lazydocker # Terminal UI for Docker
```

## Customization

### Add More Tools

#### macOS
Edit `install-tools-mac.sh` and add:
```bash
brew install your-package-name
```

#### Linux
Edit `install-tools-linux.sh` and add:
```bash
$PKG_INSTALL your-package-name
```

### Add More Dotfiles
Edit `setup.sh` and add files to the `files` variable:
```bash
files="tmux.conf gitconfig your-new-file"
```

## Troubleshooting

### macOS: Command not found after installation
Run:
```bash
source ~/.zprofile
```

### Linux: Docker permission denied
Log out and back in, then verify with:
```bash
docker run hello-world
```

### Neovim: Plugins not loading
Try:
```bash
nvim +Lazy clean +Lazy sync
```

### Fish: Not showing starship prompt
Add to `~/.config/fish/config.fish`:
```fish
starship init fish | source
```

## Uninstallation

To remove symlinks and restore original configs:
```bash
cd ~/.dotfiles
# Remove symlinks
rm ~/.tmux.conf ~/.gitconfig
rm -rf ~/.config/nvim ~/.config/fish ~/.emacs.d

# Restore backups
mv ~/.dotfiles_old/* ~/
```

## Additional Resources

- [Neovim Keybindings](config/nvim/nvim.readme) - Complete keybinding reference
- [Fish Shell Documentation](https://fishshell.com/docs/current/)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [Lazygit Documentation](https://github.com/jesseduffield/lazygit)

## Support

If you encounter issues:
1. Check the script output for errors
2. Verify your OS is supported (macOS, Ubuntu, Debian, Fedora, Arch)
3. Ensure you have sudo/admin privileges
4. Check that you have an internet connection

## Updates

To update installed tools:

### macOS
```bash
brew update && brew upgrade
```

### Linux (Ubuntu/Debian)
```bash
sudo apt update && sudo apt upgrade
```

### Linux (Fedora)
```bash
sudo dnf upgrade
```

### Linux (Arch)
```bash
sudo pacman -Syu
```

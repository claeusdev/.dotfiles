#!/bin/bash
#
# macOS Software Engineering Tools Installation Script
# This script installs common development tools and utilities using Homebrew
#
############################

set -e  # Exit on error

echo "========================================="
echo "macOS Development Tools Installation"
echo "========================================="
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed. Updating..."
    brew update
fi

echo ""
echo "Installing core development tools..."
brew install git
brew install curl
brew install wget
brew install make
brew install cmake
brew install gcc

echo ""
echo "Installing shell and terminal tools..."
brew install fish              # Modern shell
brew install tmux              # Terminal multiplexer
brew install starship          # Cross-shell prompt
brew install zoxide            # Smart directory jumper
brew install direnv            # Environment variable manager

echo ""
echo "Installing modern CLI utilities..."
brew install neovim            # Modern vim
brew install ripgrep           # Fast grep alternative (rg)
brew install fd                # Fast find alternative
brew install fzf               # Fuzzy finder
brew install bat               # Cat with syntax highlighting
brew install eza               # Modern ls replacement
brew install jq                # JSON processor
brew install yq                # YAML processor
brew install htop              # Process viewer
brew install btop              # Modern htop alternative
brew install tree              # Directory tree viewer
brew install tldr              # Simplified man pages
brew install diff-so-fancy     # Better git diffs

echo ""
echo "Installing version control tools..."
brew install gh                # GitHub CLI
brew install lazygit           # Terminal UI for git
brew install git-delta         # Better diff viewer

echo ""
echo "Installing programming languages and runtimes..."
brew install node              # Node.js
brew install python@3.12       # Python 3
brew install go                # Go
brew install rust              # Rust
brew install lua               # Lua

echo ""
echo "Installing C/C++, OCaml/SML, Lisp/Racket, and theorem proving toolchains..."
brew install llvm              # Clang/LLVM toolchain (includes clangd)
brew install bear              # compile_commands.json generator
brew install ocaml             # OCaml compiler
brew install opam              # OCaml package manager
brew install dune              # OCaml build system
brew install ocaml-lsp         # OCaml language server
brew install ocamlformat       # OCaml formatter
brew install merlin            # OCaml editor helper
brew install smlnj             # Standard ML (SML/NJ)
brew install sbcl              # Common Lisp
brew install racket            # Racket runtime
brew install coq               # Coq proof assistant
brew install agda              # Agda + agda-mode

# Optional: formula availability can vary by Homebrew setup.
if brew info isabelle > /dev/null 2>&1; then
    brew install isabelle
else
    echo "Skipping Isabelle (formula not available in this Homebrew setup)."
fi

if brew info coq-lsp > /dev/null 2>&1; then
    brew install coq-lsp
else
    echo "Skipping coq-lsp (install via OPAM if needed: opam install coq-lsp)."
fi

if command -v cargo &> /dev/null; then
    cargo install millet || true
fi

if command -v raco &> /dev/null; then
    raco pkg install --auto racket-langserver || true
fi

echo ""
echo "Installing language servers and formatters..."
brew install lua-language-server
brew install stylua            # Lua formatter
brew install black             # Python formatter
brew install ruff              # Python linter
brew install prettier          # JS/TS formatter
brew install shfmt             # Shell script formatter
brew install shellcheck        # Shell script linter

echo ""
echo "Installing database tools..."
brew install postgresql@16
brew install sqlite
brew install redis

echo ""
echo "Installing Docker and container tools..."
brew install --cask docker
brew install lazydocker        # Docker TUI

echo ""
echo "Installing cloud and DevOps tools..."
brew install awscli            # AWS CLI
brew install terraform         # Infrastructure as code
brew install kubectl           # Kubernetes CLI
brew install k9s               # Kubernetes TUI

echo ""
echo "Installing productivity tools..."
brew install --cask rectangle  # Window management
brew install --cask ghostty    # Modern GPU-accelerated terminal
brew install --cask raycast    # Spotlight replacement

echo ""
echo "Installing fonts..."
# brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-fira-code-nerd-font
brew install --cask font-hack-nerd-font
brew install --cask font-inconsolata-nerd-font

echo ""
echo "Setting up fzf key bindings..."
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

echo ""
echo "========================================="
echo "Tool installation complete!"
echo "========================================="
echo ""
echo "Installed tools:"
echo "  - Core: git, curl, wget, make, cmake, gcc"
echo "  - Shell: fish, tmux, starship, zoxide"
echo "  - CLI: neovim, ripgrep, fd, fzf, bat, eza, jq, yq"
echo "  - Languages: node, python, go, rust, lua"
echo "  - Target stack: clang/clangd, OCaml, SML, Lisp, Racket, Coq, Agda, Isabelle*"
echo "  - LSP/Formatters: Various language servers and formatters"
echo "  - Git: gh, lazygit, git-delta"
echo "  - Databases: postgresql, sqlite, redis"
echo "  - Containers: docker, lazydocker"
echo "  - Cloud: awscli, terraform, kubectl, k9s"
echo "  * Isabelle and coq-lsp are installed when available via Homebrew."
echo ""
echo "Note: Shell and app configs are managed by chezmoi."
echo "  Run 'chezmoi apply' to deploy configuration files."
echo ""

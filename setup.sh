#!/bin/bash
#
# Bootstrap script for setting up a new machine.
# Installs chezmoi, deploys dotfiles, installs development tools,
# and performs post-install setup.
#
# Usage:
#   bash <(curl -s https://raw.githubusercontent.com/naamanu/.dotfiles/main/setup.sh)
#
############################

FAILED_PACKAGES=()

# ── Optional components ───────────────────────────────────────
#
# Docker is heavyweight and not needed on every machine, so it is opt-in:
#
#   INSTALL_DOCKER=1 bash <(curl -s https://raw.githubusercontent.com/naamanu/.dotfiles/main/setup.sh)
#
INSTALL_DOCKER="${INSTALL_DOCKER:-0}"

echo "========================================="
echo "  Dotfiles Bootstrap"
echo "========================================="
echo ""

# ── 1. Detect OS ──────────────────────────────────────────────

OS="$(uname -s)"
case "$OS" in
    Linux)  PLATFORM="linux" ;;
    Darwin) PLATFORM="mac" ;;
    *)
        echo "Error: Unsupported OS '$OS'"
        exit 1
        ;;
esac
echo "Detected platform: $PLATFORM"

# ── 2. Install chezmoi ────────────────────────────────────────

# Ensure the install target is on PATH even if chezmoi is already present,
# so a chezmoi installed by a previous run is found in a fresh shell.
export PATH="$HOME/.local/bin:$PATH"

if ! command -v chezmoi &> /dev/null; then
    echo ""
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
else
    echo "chezmoi already installed."
fi

if ! command -v chezmoi &> /dev/null; then
    echo "Error: chezmoi installation failed; cannot deploy dotfiles."
    exit 1
fi

# ── 3. Deploy dotfiles ────────────────────────────────────────

echo ""
echo "Initializing dotfiles with chezmoi..."

# Use the explicit repo URL. The `chezmoi init <username>` shorthand expands to
# <username>/dotfiles, which is a *different* repo than this one (.dotfiles).
DOTFILES_SSH_URL="git@github.com:naamanu/.dotfiles.git"
DOTFILES_HTTPS_URL="https://github.com/naamanu/.dotfiles.git"

# Prefer SSH, but only when a key is actually loaded and accepted by GitHub.
# On a brand-new machine the key usually does not exist yet, and an SSH clone
# fails before any dotfiles land. GitHub returns exit 1 on a successful auth
# ("does not provide shell access"), so match the greeting instead of the code.
if ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 \
       -o BatchMode=yes -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    DOTFILES_URL="$DOTFILES_SSH_URL"
    echo "GitHub SSH auth OK; cloning over SSH."
else
    DOTFILES_URL="$DOTFILES_HTTPS_URL"
    echo "No working GitHub SSH key; cloning over HTTPS."
    echo "  (After adding a key, switch the remote with:"
    echo "   chezmoi git -- remote set-url origin $DOTFILES_SSH_URL)"
fi

SOURCE_DIR="$(chezmoi source-path 2>/dev/null || echo "$HOME/.local/share/chezmoi")"

DOTFILES_OK=1
if [ -d "$SOURCE_DIR/.git" ]; then
    # Already initialized: pull the latest and re-apply rather than re-cloning.
    echo "Existing chezmoi source dir found; updating in place."
    chezmoi update || DOTFILES_OK=0
else
    # Covers both "does not exist" and "exists but empty", the state left
    # behind by a previously failed clone.
    rmdir "$SOURCE_DIR" 2>/dev/null || true
    chezmoi init --apply "$DOTFILES_URL" || DOTFILES_OK=0
fi

if [ "$DOTFILES_OK" -ne 1 ]; then
    echo ""
    echo "Error: failed to deploy dotfiles from $DOTFILES_URL"
    echo "Fix the clone problem above and re-run this script; the tool"
    echo "installation below is skipped so the failure is not buried."
    exit 1
fi

echo "Dotfiles deployed."

# ── 4. Install development tools ─────────────────────────────

echo ""
echo "Installing development tools..."

if [ "$PLATFORM" = "mac" ]; then

    # ── macOS: Homebrew ───────────────────────────────────────

    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ $(uname -m) == 'arm64' ]]; then
            grep -qxF 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zprofile 2>/dev/null || \
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        echo "Homebrew already installed. Updating..."
        brew update
    fi

    # Helper: install brew packages, track failures, never exit
    brew_install() {
        for pkg in "$@"; do
            brew install "$pkg" || FAILED_PACKAGES+=("$pkg")
        done
    }

    brew_cask_install() {
        for pkg in "$@"; do
            brew install --cask "$pkg" || FAILED_PACKAGES+=("cask:$pkg")
        done
    }

    echo ""
    echo "Installing core development tools..."
    brew_install git curl wget make cmake gcc

    echo ""
    echo "Installing shell and terminal tools..."
    brew_install fish tmux emacs starship zoxide direnv fnm sesh

    echo ""
    echo "Installing modern CLI utilities..."
    brew_install neovim ripgrep fd fzf bat eza jq yq htop btop tree tldr diff-so-fancy
    # nvim-treesitter (main branch) compiles parsers via the tree-sitter CLI
    brew_install tree-sitter-cli
    brew_install yazi atuin glow dust procs hyperfine tokei

    echo ""
    echo "Installing version control tools..."
    brew_install gh lazygit git-delta

    echo ""
    echo "Installing programming languages and runtimes..."
    brew_install go rust lua uv

    echo ""
    echo "Installing C/C++, OCaml, and Lisp toolchains..."
    # clangd comes from the Xcode CLT; brew llvm is keg-only, so install
    # clang-format standalone to get it on PATH.
    brew_install llvm bear clang-format
    brew_install ocaml opam dune
    brew_install sbcl

    # ocaml-lsp-server, ocamlformat and merlin are OPAM packages, not Homebrew
    # formulae — installing them with brew always failed silently.
    if command -v opam &> /dev/null; then
        if [ ! -d "$HOME/.opam" ]; then
            opam init -a --disable-sandboxing --shell-setup || true
        fi
        eval "$(opam env 2>/dev/null)" || true
        opam install -y ocaml-lsp-server ocamlformat merlin utop || true
    fi

    echo ""
    echo "Installing language servers and formatters..."
    brew_install lua-language-server stylua black ruff prettier shfmt shellcheck

    echo ""
    echo "Installing database tools..."
    brew_install postgresql@16 sqlite redis

    echo ""
    if [ "$INSTALL_DOCKER" = "1" ]; then
        echo "Installing Docker and container tools..."
        brew_cask_install docker-desktop
        brew_install lazydocker
    else
        echo "Skipping Docker (set INSTALL_DOCKER=1 to install Docker Desktop + lazydocker)."
    fi

    echo ""
    echo "Installing cloud and DevOps tools..."
    brew_install awscli terraform kubectl k9s

    echo ""
    echo "Installing ML/AI & scientific tools..."
    brew_install jupyterlab ipython pandoc typst ollama
    brew_cask_install mactex-no-gui

    echo ""
    echo "Installing productivity tools..."
    brew_cask_install rectangle ghostty raycast
    brew_cask_install nikitabobko/tap/aerospace jordanbaird-ice

    echo ""
    echo "Installing fonts..."
    brew_cask_install font-jetbrains-mono-nerd-font font-fira-code-nerd-font font-hack-nerd-font font-inconsolata-nerd-font

    echo ""
    echo "Setting up fzf key bindings..."
    "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc || true

elif [ "$PLATFORM" = "linux" ]; then

    # ── Linux: apt / dnf / pacman ─────────────────────────────

    if command -v apt &> /dev/null; then
        PKG_MGR="apt"
        PKG_UPDATE="sudo apt update"
        PKG_INSTALL="sudo apt install -y"
        echo "Detected package manager: apt (Debian/Ubuntu)"
    elif command -v dnf &> /dev/null; then
        PKG_MGR="dnf"
        PKG_UPDATE="sudo dnf check-update || true"
        PKG_INSTALL="sudo dnf install -y"
        echo "Detected package manager: dnf (Fedora)"
    elif command -v pacman &> /dev/null; then
        PKG_MGR="pacman"
        PKG_UPDATE="sudo pacman -Sy"
        PKG_INSTALL="sudo pacman -S --noconfirm"
        echo "Detected package manager: pacman (Arch)"
    else
        echo "Error: No supported package manager found (apt, dnf, or pacman)"
        exit 1
    fi

    install_pkg() {
        $PKG_INSTALL "$@" || FAILED_PACKAGES+=("$@")
    }

    install_optional_pkg() {
        local pkg="$1"
        $PKG_INSTALL "$pkg" > /dev/null 2>&1 || {
            echo "Skipping optional package: $pkg (not available)."
            return 0
        }
        echo "Installed optional package: $pkg"
    }

    echo ""
    echo "Updating package lists..."
    $PKG_UPDATE

    echo ""
    echo "Installing core development tools..."
    if [ "$PKG_MGR" = "apt" ]; then
        install_pkg build-essential git curl wget cmake pkg-config libssl-dev
    elif [ "$PKG_MGR" = "dnf" ]; then
        install_pkg gcc gcc-c++ make git curl wget cmake openssl-devel
    elif [ "$PKG_MGR" = "pacman" ]; then
        install_pkg base-devel git curl wget cmake openssl
    fi

    echo ""
    echo "Installing shell and terminal tools..."
    install_pkg fish tmux emacs

    if ! command -v starship &> /dev/null; then
        echo "Installing starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y || FAILED_PACKAGES+=(starship)
    fi

    echo ""
    echo "Installing modern CLI utilities..."
    if [ "$PKG_MGR" = "apt" ]; then
        install_pkg neovim ripgrep fd-find fzf bat htop tree jq
        mkdir -p ~/.local/bin
        ln -sf /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || true
        ln -sf /usr/bin/fdfind ~/.local/bin/fd 2>/dev/null || true
    elif [ "$PKG_MGR" = "dnf" ]; then
        install_pkg neovim ripgrep fd-find fzf bat htop tree jq
    elif [ "$PKG_MGR" = "pacman" ]; then
        install_pkg neovim ripgrep fd fzf bat htop tree jq
    fi

    # nvim-treesitter (main branch) compiles parsers via the tree-sitter CLI.
    # Distro packages are often missing or stale; cargo is the reliable path.
    if ! command -v tree-sitter &> /dev/null; then
        install_optional_pkg tree-sitter-cli
        if ! command -v tree-sitter &> /dev/null && command -v cargo &> /dev/null; then
            cargo install tree-sitter-cli
        fi
    fi

    if ! command -v eza &> /dev/null; then
        echo "Installing eza..."
        if [ "$PKG_MGR" = "apt" ]; then
            wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
            echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
            sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
            sudo apt update
            sudo apt install -y eza || FAILED_PACKAGES+=(eza)
        else
            install_pkg eza
        fi
    fi

    if ! command -v btop &> /dev/null; then
        install_pkg btop
    fi

    if ! command -v zoxide &> /dev/null; then
        echo "Installing zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash || FAILED_PACKAGES+=(zoxide)
    fi

    echo ""
    echo "Installing additional modern CLI tools..."
    install_optional_pkg dust
    install_optional_pkg procs
    install_optional_pkg hyperfine
    install_optional_pkg tokei
    install_optional_pkg glow

    if ! command -v yazi &> /dev/null; then
        if command -v cargo &> /dev/null; then
            cargo install yazi-fm yazi-cli || FAILED_PACKAGES+=(yazi)
        fi
    fi

    if ! command -v atuin &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh || FAILED_PACKAGES+=(atuin)
    fi

    echo ""
    echo "Installing version control tools..."
    if [ "$PKG_MGR" = "apt" ]; then
        if ! command -v gh &> /dev/null; then
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update
            sudo apt install -y gh || FAILED_PACKAGES+=(gh)
        fi
    elif [ "$PKG_MGR" = "dnf" ]; then
        install_pkg gh
    elif [ "$PKG_MGR" = "pacman" ]; then
        install_pkg github-cli
    fi

    if ! command -v lazygit &> /dev/null; then
        echo "Installing lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
    fi

    if ! command -v delta &> /dev/null; then
        echo "Installing git-delta..."
        if [ "$PKG_MGR" = "apt" ]; then
            DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
            curl -Lo delta.deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${DELTA_VERSION}_amd64.deb"
            sudo dpkg -i delta.deb || FAILED_PACKAGES+=(git-delta)
            rm -f delta.deb
        else
            install_pkg git-delta
        fi
    fi

    echo ""
    echo "Installing programming languages and runtimes..."

    if ! command -v node &> /dev/null; then
        echo "Installing Node.js via nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts
    fi

    if ! command -v uv &> /dev/null; then
        echo "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh || FAILED_PACKAGES+=(uv)
    fi

    if ! command -v rustc &> /dev/null; then
        echo "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi

    if ! command -v go &> /dev/null; then
        echo "Installing Go..."
        GO_VERSION=$(curl -s 'https://go.dev/VERSION?m=text' | head -1 | sed 's/go//')
        wget "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
        rm "go${GO_VERSION}.linux-amd64.tar.gz"
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
    fi

    $PKG_INSTALL lua5.4 || $PKG_INSTALL lua || true

    echo ""
    echo "Installing C/C++, OCaml, and Lisp toolchains..."
    if [ "$PKG_MGR" = "apt" ]; then
        install_pkg clang clangd clang-format lldb bear ocaml opam
    elif [ "$PKG_MGR" = "dnf" ]; then
        # clang-tools-extra provides clangd and clang-format
        install_pkg clang clang-tools-extra lldb bear ocaml opam
    elif [ "$PKG_MGR" = "pacman" ]; then
        # clang provides clangd and clang-format
        install_pkg clang llvm lldb bear ocaml opam
    fi

    install_optional_pkg dune
    install_optional_pkg ocaml-dune
    install_optional_pkg sbcl

    if command -v opam &> /dev/null; then
        if [ ! -d "$HOME/.opam" ]; then
            opam init -a --disable-sandboxing --shell-setup || true
        fi
        eval "$(opam env 2>/dev/null)" || true
        opam install -y ocaml-lsp-server ocamlformat merlin utop || true
    fi

    echo ""
    echo "Installing language servers and formatters..."
    if command -v npm &> /dev/null; then
        npm install -g prettier eslint typescript || true
    fi

    if command -v cargo &> /dev/null; then
        cargo install stylua || true
    fi

    install_pkg shellcheck

    echo ""
    echo "Installing database tools..."
    if [ "$PKG_MGR" = "apt" ]; then
        install_pkg postgresql postgresql-contrib sqlite3
    elif [ "$PKG_MGR" = "dnf" ]; then
        install_pkg postgresql postgresql-server sqlite
    elif [ "$PKG_MGR" = "pacman" ]; then
        install_pkg postgresql sqlite
    fi

    echo ""
    if [ "$INSTALL_DOCKER" = "1" ]; then
        echo "Installing Docker..."
        if ! command -v docker &> /dev/null; then
            if [ "$PKG_MGR" = "apt" ]; then
                curl -fsSL https://get.docker.com -o get-docker.sh
                sudo sh get-docker.sh
                sudo usermod -aG docker "$USER"
                rm get-docker.sh
            else
                install_pkg docker docker-compose
                sudo systemctl start docker
                sudo systemctl enable docker
                sudo usermod -aG docker "$USER"
            fi
        fi

        if ! command -v lazydocker &> /dev/null; then
            echo "Installing lazydocker..."
            curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash || FAILED_PACKAGES+=(lazydocker)
        fi
    else
        echo "Skipping Docker (set INSTALL_DOCKER=1 to install Docker + lazydocker)."
    fi

    echo ""
    echo "Installing ML/AI & scientific tools..."
    install_pkg pandoc
    if [ "$PKG_MGR" = "apt" ]; then
        install_pkg texlive-full
    elif [ "$PKG_MGR" = "dnf" ]; then
        install_pkg texlive-scheme-full
    elif [ "$PKG_MGR" = "pacman" ]; then
        install_pkg texlive-most
    fi

    if ! command -v typst &> /dev/null; then
        if command -v cargo &> /dev/null; then
            cargo install typst-cli || FAILED_PACKAGES+=(typst)
        fi
    fi

    if ! command -v ollama &> /dev/null; then
        curl -fsSL https://ollama.com/install.sh | sh || FAILED_PACKAGES+=(ollama)
    fi

    echo ""
    echo "Installing Ghostty terminal..."
    if ! command -v ghostty &> /dev/null; then
        if [ "$PKG_MGR" = "apt" ]; then
            sudo apt install -y libgtk-4-dev libadwaita-1-dev git
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)" || FAILED_PACKAGES+=(ghostty)
        elif [ "$PKG_MGR" = "pacman" ]; then
            echo "Note: Install ghostty from AUR using your AUR helper"
            echo "Example: yay -S ghostty"
        fi
    fi

    echo ""
    echo "Installing fonts..."
    mkdir -p ~/.local/share/fonts

    if [ ! -f ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf ]; then
        echo "Installing JetBrains Mono Nerd Font..."
        wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
        unzip -o JetBrainsMono.zip -d ~/.local/share/fonts/
        rm JetBrainsMono.zip
    fi

    if [ ! -f ~/.local/share/fonts/InconsolataNerdFont-Regular.ttf ]; then
        echo "Installing Inconsolata Nerd Font..."
        wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Inconsolata.zip
        unzip -o Inconsolata.zip -d ~/.local/share/fonts/
        rm Inconsolata.zip
    fi

    fc-cache -fv
fi

# ── 5. Post-install setup ─────────────────────────────────────

echo ""
echo "Running post-install setup..."

# Clone TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    echo "TPM already installed."
fi

# Set up Neovim Python provider
if command -v uv &> /dev/null; then
    echo "Setting up Neovim Python provider..."
    uv venv ~/.local/share/nvim/venv
    ~/.local/share/nvim/venv/bin/pip install pynvim
fi

# ML/AI & Scientific Python tools (global uv tools)
if command -v uv &> /dev/null; then
    echo "Installing ML/AI & Scientific Python tools..."
    uv tool install jupyterlab --with ipykernel --with jupyterlab-vim || true
    uv tool install ipython || true
    uv tool install mlflow || true
    uv tool install dvc || true
    uv tool install tensorboard || true
fi

# Install Node.js LTS via fnm
if command -v fnm &> /dev/null; then
    echo "Installing Node.js LTS via fnm..."
    fnm install --lts
fi

# Set fish as default shell
FISH_PATH="$(command -v fish 2>/dev/null || true)"
if [ -n "$FISH_PATH" ]; then
    if [ "$PLATFORM" = "mac" ]; then
        CURRENT_SHELL="$(dscl . -read /Users/"$USER" UserShell 2>/dev/null | awk '{print $2}' || true)"
    else
        CURRENT_SHELL="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || true)"
    fi
    if [ "$CURRENT_SHELL" != "$FISH_PATH" ]; then
        echo "Setting fish as default shell..."
        if ! grep -qxF "$FISH_PATH" /etc/shells 2>/dev/null; then
            echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
        fi
        chsh -s "$FISH_PATH"
    else
        echo "fish is already the default shell."
    fi
else
    echo "Warning: fish not found. Skipping default shell change."
fi

# ── 6. Summary ─────────────────────────────────────────────────

echo ""
echo "========================================="
echo "  Bootstrap complete!"
echo "========================================="
echo ""
echo "What was done:"
echo "  - chezmoi installed and dotfiles deployed"
echo "  - Development tools installed ($PLATFORM)"
echo "  - TPM (Tmux Plugin Manager) installed"
echo "  - Default shell set to fish"

if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
    echo ""
    echo "Failed to install:"
    for pkg in "${FAILED_PACKAGES[@]}"; do
        echo "  - $pkg"
    done
fi

echo ""
echo "Manual next steps:"
echo "  1. Restart your terminal (or log out and back in)"
echo "  2. Install Neovim plugins:  nvim '+Lazy sync' +qa"
echo "  3. Install tmux plugins:    prefix + I  (inside tmux)"
if [ "$PLATFORM" = "linux" ] && [ "$INSTALL_DOCKER" = "1" ]; then
echo "  4. Log out/in for Docker group changes"
fi
if [ "$INSTALL_DOCKER" != "1" ]; then
echo ""
echo "Docker was skipped. To include it, re-run with INSTALL_DOCKER=1."
fi
echo ""

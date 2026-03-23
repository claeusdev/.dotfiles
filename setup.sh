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

set -e

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

if ! command -v chezmoi &> /dev/null; then
    echo ""
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "chezmoi already installed."
fi

# ── 3. Deploy dotfiles ────────────────────────────────────────

echo ""
echo "Initializing dotfiles with chezmoi..."
chezmoi init --apply --ssh naamanu

CHEZMOI_SOURCE="$(chezmoi source-path)"

# ── 4. Install development tools ──────────────────────────────

echo ""
if [ "$PLATFORM" = "linux" ]; then
    echo "Running Linux tool installer..."
    bash "$CHEZMOI_SOURCE/install-tools-linux.sh"
elif [ "$PLATFORM" = "mac" ]; then
    echo "Running macOS tool installer..."
    bash "$CHEZMOI_SOURCE/install-tools-mac.sh"
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

# Set fish as default shell
FISH_PATH="$(command -v fish 2>/dev/null || true)"
if [ -n "$FISH_PATH" ]; then
    CURRENT_SHELL="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || dscl . -read /Users/"$USER" UserShell 2>/dev/null | awk '{print $2}' || true)"
    if [ "$CURRENT_SHELL" != "$FISH_PATH" ]; then
        echo "Setting fish as default shell..."
        # Ensure fish is in /etc/shells
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
echo ""
echo "Manual next steps:"
echo "  1. Restart your terminal (or log out and back in)"
echo "  2. Install Neovim plugins:  nvim '+Lazy sync' +qa"
echo "  3. Install tmux plugins:    prefix + I  (inside tmux)"
echo "  4. Log out/in for Docker group changes (Linux)"
echo ""

# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/). Source directory: `~/.local/share/chezmoi`.

## Managing dotfiles with chezmoi

**Edit a dotfile:**
```sh
chezmoi edit ~/.tmux.conf            # opens the source file in $EDITOR
chezmoi apply                        # deploy changes to $HOME
chezmoi edit --apply ~/.tmux.conf    # edit + apply in one step
```

**Preview changes before applying:**
```sh
chezmoi diff
```

**Add a new file to chezmoi:**
```sh
chezmoi add ~/.config/wezterm/wezterm.lua
```

**Common commands:**

| Command | Description |
| :--- | :--- |
| `chezmoi edit <file>` | Edit the source version of a managed file |
| `chezmoi apply` | Deploy source state to `$HOME` |
| `chezmoi diff` | Preview pending changes |
| `chezmoi add <file>` | Start managing a new file |
| `chezmoi forget <file>` | Stop managing a file |
| `chezmoi managed` | List all managed files |
| `chezmoi cd` | cd into the source directory (for git operations) |
| `chezmoi update` | `git pull` + `apply` in one step |

**Committing changes:**
```sh
chezmoi cd
git add -A && git commit -m "message" && git push
exit
```

**Setting up on a new machine (full bootstrap — chezmoi + tools + post-setup):**
```sh
bash <(curl -s https://raw.githubusercontent.com/naamanu/.dotfiles/main/setup.sh)
```

Or deploy dotfiles only (no tool installation):
```sh
chezmoi init --apply naamanu
```

See [INSTALL.md](INSTALL.md) for details and manual alternatives.

---

# Editor Documentation

- [nvim.md](nvim.md) — Neovim setup, plugins, and keybindings
- [emacs.md](emacs.md) — Emacs setup, packages, and keybindings
- [tmux.md](tmux.md) — tmux setup, plugins, and keybindings

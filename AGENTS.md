# Repository Guidelines

## Project Structure & Module Organization
This repository manages personal development environment dotfiles via [chezmoi](https://chezmoi.io).

- `setup.sh`: one-command bootstrap — installs chezmoi, deploys dotfiles, installs tools, sets fish as default shell.
- `install-tools-mac.sh`, `install-tools-linux.sh`: OS-specific tool installers (called by `setup.sh`).
- `dot_config/`: maps to `~/.config/` after `chezmoi apply`:
  - `dot_config/nvim/` (Neovim; Lua modules under `lua/naamanu/{core,exact_plugins}`)
  - `dot_config/fish/` (fish shell config, functions, completions; includes `mlenv` and `jk` ML helpers, atuin integration)
  - `dot_config/aerospace/` (AeroSpace tiling WM config)
  - `dot_config/ghostty/` and `dot_config/starship.toml`
- `dot_emacs.d/`: maps to `~/.emacs.d/` (`elisp/core`, `elisp/plugins`, `init.el`).
- `dot_tmux.conf`: maps to `~/.tmux.conf`.
- `dot_gitconfig`: maps to `~/.gitconfig`.

## Build, Test, and Development Commands
- `chezmoi apply`: deploy source state to `$HOME`.
- `chezmoi update`: pull latest from remote and apply.
- `chezmoi add <file>`: start tracking a new dotfile.
- `./setup.sh`: full bootstrap on a fresh machine.
- `./install-tools-mac.sh` or `./install-tools-linux.sh`: install toolchain and CLI dependencies.
- `fish -n dot_config/fish/config.fish`: syntax-check fish config.
- `bash -n setup.sh install-tools-mac.sh install-tools-linux.sh`: syntax-check Bash scripts.
- `shellcheck setup.sh install-tools-mac.sh install-tools-linux.sh`: lint shell scripts before PRs.

## Coding Style & Naming Conventions
- Shell scripts: Bash with `set -e`, 4-space indentation, descriptive section comments.
- Lua (Neovim): 2-space indentation; keep modules focused and grouped by feature under `lua/naamanu/plugins`.
- Emacs Lisp: follow existing `el-*.el` naming and kebab-case symbols.
- Keep generated/local files out of commits (`.DS_Store`, `dot_config/fish/fish_variables`, `.emacs.d/elpa`, caches listed in `.gitignore`).

## Testing Guidelines
There is no formal automated test suite in this repo. Use targeted validation for changed areas:

- Shell: `bash -n` + `shellcheck`.
- Fish: `fish -n`.
- Neovim/Emacs/tmux: start each tool and confirm no startup errors after edits.

## Commit & Pull Request Guidelines
Recent history follows Conventional Commit prefixes: `feat:`, `fix:`, `chore:`.

- Write concise, imperative commit subjects (example: `fix: correct Ghostty theme name`).
- Keep PRs scoped to one area (e.g., fish, nvim, emacs, tmux, install scripts).
- PR description should include: what changed, target OS(es) tested (macOS/Linux), and manual validation commands run.

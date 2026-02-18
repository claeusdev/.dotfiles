# Repository Guidelines

## Project Structure & Module Organization
This repository manages personal development environment dotfiles.

- `setup.sh`: creates symlinks from this repo into `$HOME` and initializes submodules.
- `install-tools-mac.sh`, `install-tools-linux.sh`: OS-specific bootstrap scripts.
- `config/`: user config files:
  - `config/nvim/` (Neovim; Lua modules under `lua/naamanu/{core,plugins}`)
  - `config/fish/` (fish shell config, functions, completions)
  - `config/ghostty/` and `config/starship.toml`
- `.emacs.d/`: Emacs config (`elisp/core`, `elisp/plugins`, `init.el`).
- `tmux.conf`, `gitconfig`: top-level managed dotfiles.

## Build, Test, and Development Commands
- `./setup.sh`: link configs into `~/.config`/`~` and back up existing files to `~/.dotfiles_old`.
- `./install-tools-mac.sh` or `./install-tools-linux.sh`: install toolchain and CLI dependencies.
- `git submodule update --init --recursive`: sync submodules after clone/update.
- `fish -n config/fish/config.fish`: syntax-check fish config.
- `bash -n setup.sh install-tools-mac.sh install-tools-linux.sh`: syntax-check Bash scripts.
- `shellcheck setup.sh install-tools-mac.sh install-tools-linux.sh`: lint shell scripts before PRs.

## Coding Style & Naming Conventions
- Shell scripts: Bash with `set -e`, 4-space indentation, descriptive section comments.
- Lua (Neovim): 2-space indentation; keep modules focused and grouped by feature under `lua/naamanu/plugins`.
- Emacs Lisp: follow existing `el-*.el` naming and kebab-case symbols.
- Keep generated/local files out of commits (`.DS_Store`, `config/fish/fish_variables`, `.emacs.d/elpa`, caches listed in `.gitignore`).

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

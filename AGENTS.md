# Repository Guidelines

## Project Structure & Module Organization
This repository is a chezmoi-managed dotfiles source tree. Files named with chezmoi conventions map into `$HOME` after `chezmoi apply`.

- `dot_config/nvim/`: Neovim config. Core Lua lives in `lua/naamanu/core/`; plugin specs live in `lua/naamanu/exact_plugins/`.
- `dot_config/fish/`: fish shell config, completions, functions, and `conf.d/` startup snippets.
- `dot_emacs.d/`: Emacs config, split into `elisp/core/` and `elisp/plugins/`.
- `dot_config/ghostty/`, `dot_tmux.conf`, `dot_config/aerospace/`, `dot_config/starship.toml`: terminal, tmux, window manager, and prompt configuration.
- `setup.sh`: bootstrap entry point for a new machine. Documentation lives in `README.md`, `INSTALL.md`, and tool-specific `*.md` guides.

## Build, Test, and Development Commands
- `chezmoi diff`: preview changes before applying them to `$HOME`.
- `chezmoi apply`: apply managed dotfiles. Use targeted paths, for example `chezmoi apply ~/.config/nvim`, when unrelated local files are dirty.
- `chezmoi add <path>`: import an existing home-directory file into the source tree.
- `nvim --headless +qa`: validate Neovim startup.
- `nvim --headless '+checkhealth vim.deprecated' '+qa'`: check for deprecated Neovim APIs.
- `fish -n dot_config/fish/config.fish`: syntax-check fish config.
- `bash -n setup.sh`: syntax-check shell bootstrap scripts.

## Coding Style & Naming Conventions
Keep edits small and grouped by tool. Lua uses Stylua formatting and feature-focused modules. Fish and shell scripts should be readable, explicit, and avoid hidden side effects. ChezMoi source names must preserve mapping conventions, such as `dot_tmux.conf` for `~/.tmux.conf` and `dot_config/...` for `~/.config/...`.

Do not commit generated or machine-local state such as caches, plugin install directories, `.DS_Store`, or fish variables.

## Testing Guidelines
There is no formal test suite. Validate the changed tool directly:

- Neovim: headless startup plus relevant `:checkhealth` target.
- tmux: `tmux -L test -f ~/.tmux.conf start-server`.
- fish: `fish -n` for edited scripts.
- shell: `bash -n`; run `shellcheck` when available.

## Commit & Pull Request Guidelines
Recent history uses short imperative subjects, sometimes with conventional prefixes. Prefer focused messages such as `fix: restore python lsp config` or `simplify tmux theme`.

Pull requests should describe what changed, which dotfiles are affected, and what validation commands were run. Include screenshots only for visible UI/theme changes.

## Agent-Specific Instructions
Work in the chezmoi source tree, not only the applied `$HOME` files. After edits, apply targeted paths and avoid touching unrelated dirty files, especially local shell state.

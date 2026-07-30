---
name: dotfiles-bootstrap
description: Use when setting up these dotfiles on a new machine, re-running or debugging setup.sh, or walking through the post-install checklist (Neovim plugins, tmux TPM, Emacs first run, gh auth, fish as default shell). Also use for "why is X missing on this machine" questions after a fresh install.
---

# Bootstrapping a new machine

One command does everything (idempotent, safe to re-run):

```sh
bash <(curl -s https://raw.githubusercontent.com/naamanu/.dotfiles/main/setup.sh)
```

It installs chezmoi, clones and applies the dotfiles via SSH, installs
platform-appropriate packages (Homebrew on macOS; apt/dnf/pacman on Linux),
then does post-install setup (TPM, fish as default shell). `setup.sh`
installs packages ONLY — all config files come from `chezmoi apply`.

## Post-install checklist (in order)

1. Restart the terminal (or `source ~/.zprofile` on macOS).
2. `nvim '+Lazy sync' +qa` — install Neovim plugins.
3. In tmux: `prefix + I` — install tmux plugins.
4. `gh auth login` — GitHub CLI; Emacs Forge reuses this token.
5. `git clone git@github.com:naamanu/notes.git ~/workspace/learn/notes` — the
   `~/.claude/skills/*` symlinks are chezmoi-managed but point into this repo's
   `.claude/skills/`; they dangle (all global Claude skills silently missing)
   until it exists at exactly this path.
6. Linux only: log out/in for the Docker group.

## Neovim first run

1. `nvim` — lazy.nvim bootstraps itself and installs all plugins; treesitter
   parsers compile automatically on first start (needs the `tree-sitter` CLI,
   installed by setup.sh; macOS: `brew install tree-sitter-cli`).
2. `:MasonToolsInstallSync` — install LSP servers/formatters (basedpyright,
   vtsls, rust-analyzer, etc.) without waiting for the background installer.
3. `:checkhealth` — confirm treesitter parsers, LSP, and providers.
4. cc-nvim (`<leader>a` group) uses the local checkout at `~/projects/cc-nvim`
   when present, otherwise the GitHub copy.

## Emacs first run

1. Launch Emacs — `use-package` auto-installs all packages from ELPA/MELPA
   on the first start (needs network; takes a few minutes).
2. `C-c e g` (`M-x my/install-missing-grammars`) — compile tree-sitter
   grammars (needs a C compiler).
3. `C-c e h` (`M-x my/emacs-health-check`) — shows which external tools are
   missing and what each is for. LSPs/formatters are optional per language.
4. LaTeX previews in Org need a TeX distribution providing `latex` and
   `dvisvgm` (macOS: `brew install texlive`, no sudo needed).
5. gptel reads the Anthropic key from `~/.authinfo.gpg` (never env vars):
   `machine api.anthropic.com login apikey password sk-ant-...`
6. Machine-local overrides go in `~/.emacs.d/local-pre.el` /
   `local-post.el` — created by hand, never managed by chezmoi.
7. Python debugging (dape) is per-project: `uv add --dev debugpy`.

## Verifying a bootstrap

- `chezmoi status` — empty means source and `$HOME` agree.
- `emacs --batch -l ~/.emacs.d/init.el` — exit 0.
- `nvim --headless +qa`, `fish -n ~/.config/fish/config.fish`.

## Updating an existing machine

`chezmoi update` (pull + apply), then the platform package manager upgrade
(`brew update && brew upgrade`, `apt upgrade`, ...).

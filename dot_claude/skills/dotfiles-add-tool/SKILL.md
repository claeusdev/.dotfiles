---
name: dotfiles-add-tool
description: Use when adding a new external tool to the dotfiles — a CLI, language server, formatter, debugger, font, or Emacs/Neovim package — so it lands everywhere it needs to (setup.sh, Emacs health check, INSTALL.md, editor config) instead of only on the current machine.
---

# Adding a tool to the dotfiles

A tool added only on this machine silently breaks the next bootstrap. Touch
every checkpoint that applies, in the chezmoi source tree, then sync.

## Checklist

1. **Install it here** the same way `setup.sh` would (brew formula, `uv tool
   install`, etc.) and verify it works.
2. **`setup.sh`** — add it to the right section (core / CLI / languages /
   LSP-formatters / macOS-only). Match the existing `install_pkg` /
   `brew_install` / `install_optional_pkg` idiom, and handle both platforms
   or use the platform-specific branch. `bash -n setup.sh` after.
3. **Emacs health check** — if Emacs invokes the binary, add a row to
   `my/emacs-health-checks` in `dot_emacs.d/elisp/core.el` (`required` only
   if core workflows break without it). Skip Python modules installed
   per-project with `uv add --dev` — dape and friends resolve those through
   the project environment.
4. **Editor wiring** — as applicable:
   - Emacs LSP: `eglot-server-programs` entry (dev.el) + `my/eglot-ensure-when-executable`
     in the language's hook (langs.el)
   - Emacs formatter: `apheleia-mode-alist` (dev.el)
   - Emacs package: `use-package` form in the right module + name added to
     `package-selected-packages` in machine-local `~/.emacs.d/custom.el`
   - Neovim LSP: `lsp.config(...)` + `mason_servers` entry in `core/lsp.lua`,
     mason package in `ensure_installed` (plugins/lsp.lua); the two editors
     should use the SAME server per language (e.g. basedpyright, vtsls)
   - Neovim formatter/linter: conform (plugins/formatting.lua) / nvim-lint
     (plugins/linting.lua) — skip linters whose LSP already publishes diagnostics
   - Neovim language: parser in `ensure_installed` (plugins/treesitter.lua)
   - Neovim plugin: spec file in `lua/naamanu/plugins/`, then
     `nvim --headless "+Lazy! sync" +qa` and sync `lazy-lock.json` too
5. **`INSTALL.md`** — add it to the "What Gets Installed" list.
6. **Verify**: `emacs --batch -l ~/.emacs.d/init.el` exits 0; re-run the
   health check if you changed it.
7. **Sync**: `chezmoi add` any `$HOME` files you edited; confirm with
   `chezmoi status`. Commit one tool per commit when asked.

## Removal is the same list in reverse

Also remove the package from `package-selected-packages` so
`package-autoremove` can collect it, and delete any keybindings in `keys.el`.

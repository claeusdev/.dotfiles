# Emacs Configuration Structure

This directory contains the modular Emacs configuration. The main `init.el` file loads the modules from here. `early-init.el` (in the parent directory) runs before `init.el` for startup optimization.

## Structure

- `core/`: Core Emacs configuration files.
  - `el-core.el`: Basic Emacs settings, UI defaults, GC reset hook.
  - `el-packages.el`: Package management setup (`package.el`, `use-package`).
  - `el-bindings.el`: Global keybindings and FP/research REPL commands.
- `plugins/`: Plugin and feature configuration.
  - `el-theme.el`: Theme and appearance settings.
  - `el-completion.el`: Completion setup (Vertico, Corfu).
  - `el-dev-tools.el`: Development tools and git integration.
  - `el-lsp.el`: LSP (Eglot) — Python, Julia, OCaml, Haskell, C/C++, etc.
  - `el-languages.el`: Language modes — FP (OCaml, Haskell, Coq, Lean, Agda), research (Python, Julia), systems (C/C++).
  - `el-latex.el`: LaTeX editing — AUCTeX, pdf-tools, cdlatex.
  - `el-org.el`: Org Mode — agenda, capture, babel, roam, citar.
  - `el-treemacs.el`: Treemacs file explorer.
  - `el-vterm.el`: Vterm terminal emulator.
  - `el-evil.el`: Evil mode (Vim keybindings).
  - `el-session.el`: Session management (desktop-save-mode).
  - `el-which-key.el`: Keybinding discovery.

## Adding New Configurations

Create a new `.el` file in the appropriate directory (`core` or `plugins`) and then `require` it in the main `init.el` file.

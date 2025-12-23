# Emacs Configuration Structure

This directory contains the modular Emacs configuration. The main `init.el` file loads the modules from here.

## Structure

- `core/`: Contains the core Emacs configuration files.
  - `el-core.el`: Basic Emacs settings, UI, and startup optimizations.
  - `el-packages.el`: Package management setup (`package.el`, `use-package`).
  - `el-bindings.el`: Global keybindings.
- `plugins/`: Contains the configuration for various plugins.
  - `el-theme.el`: Theme and appearance settings.
  - `el-completion.el`: Completion setup.
  - `el-dev-tools.el`: Development tools.
  - `el-lsp.el`: LSP (Eglot) setup.
  - `el-languages.el`: Language-specific configurations.
  - `el-org.el`: Org Mode setup.
  - `el-treemacs.el`: Treemacs file explorer setup.
  - `el-vterm.el`: Vterm setup.
  - `el-evil.el`: Evil mode setup.

## Adding New Configurations

To add a new configuration, create a new `.el` file in the appropriate directory (`core` or `plugins`) and then `require` it in the main `init.el` file.

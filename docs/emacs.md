# Emacs Setup

**Package manager**: use-package
**LSP client**: Eglot
**Theme**: Modus Vivendi
**Config**: `~/.emacs.d/`
**Project layer**: built-in `project.el`
**Health check**: `C-c e h`

---

## Structure

```text
early-init.el
init.el
elisp/
  core/
    el-packages.el
    el-core.el
    el-bindings.el
  plugins/
    el-theme.el
    el-completion.el
    el-git.el
    el-lsp.el
    el-languages.el
    el-org.el
    el-tools.el
```

---

## Philosophy

This Emacs config now mirrors the Neovim setup: completion, LSP, formatting, project tasks, Git, notes, and a narrow language stack. It intentionally avoids a built-in DAP/debug layer and avoids broad proof/research language packages by default.

---

## Language Support

| Language | Mode / Tooling |
| :--- | :--- |
| C/C++ | built-in C/C++ or tree-sitter modes, clangd, clang-format |
| Python | python / python-ts-mode, Ruff, Ty, pytest helpers |
| Rust | rust-ts-mode or rust-mode, rust-analyzer, cargo |
| TypeScript / JavaScript / React | built-in js/typescript tree-sitter modes, vtsls, Prettier |
| Vue | mhtml-mode, Prettier |
| CSS | css/css-ts-mode, CSS LSP, Prettier |
| SQL | sql-mode, sql-formatter |
| OCaml | tuareg, ocamllsp, merlin fallback |
| Haskell | haskell-mode, HLS |
| JSON / YAML / Markdown | built-in/json-ts, yaml-mode, markdown-mode, Prettier |

---

## Key Packages

| Area | Packages |
| :--- | :--- |
| Completion | vertico, orderless, marginalia, consult, embark, corfu, cape |
| Git | magit, diff-hl |
| Project/tasks | project.el, compile, vterm, consult-ripgrep |
| Formatting | apheleia |
| Editing | avy, editorconfig, wgrep |
| UI | modus-themes, doom-modeline, nerd-icons, rainbow-delimiters, which-key |
| Notes | org, org-roam, citar, org-noter |
| Writing | olivetti, jinx, writegood-mode |

---

## Keybindings

### General

| Key | Action |
| :--- | :--- |
| `ESC` | Keyboard escape/quit |
| `M-o` | Other window |
| `C-c w` | Delete window |
| `C-c r` | Replace string |
| `C-c e h` | Emacs health check |

### Search

| Key | Action |
| :--- | :--- |
| `C-c s l` | Search current buffer |
| `C-c s s` | Search current project |
| `C-c s r` | Ripgrep from chosen root |
| `C-c s i` | Consult imenu |
| `C-c s o` | Consult outline |
| `C-c j` | Avy jump |

### Projects

| Key | Action |
| :--- | :--- |
| `C-c p p` | Switch project |
| `C-c p P` | Switch project and find file |
| `C-c p f` | Find file in current project |
| `C-c p b` | Switch project buffer |
| `C-c p D` | Project Dired |
| `C-c p s` | Search project |
| `C-c p m` | Compile/build project |
| `C-c p t` | Run project tests |
| `C-c p v` | Project vterm |

### LSP

| Key | Action |
| :--- | :--- |
| `C-c l a` | Code actions |
| `C-c l d` | Find definition |
| `C-c l D` | Find references |
| `C-c l i` | Find implementation |
| `C-c l t` | Find type definition |
| `C-c l f` | Format buffer |
| `C-c l r` | Rename symbol |
| `C-c l e` | Buffer diagnostics |
| `C-c l n` / `C-c l p` | Next / previous diagnostic |

### REPLs

| Key | Action |
| :--- | :--- |
| `C-c f h` | Haskell REPL |
| `C-c f o` | OCaml REPL |
| `C-c f e` | Emacs Lisp REPL |

### Notes

| Key | Action |
| :--- | :--- |
| `C-c a` | Org agenda |
| `C-c c` | Org capture |
| `C-c n i` | Open inbox |
| `C-c n p` | Open projects |
| `C-c n j` | Open journal |
| `C-c n s` | Search notes |
| `C-c n f` | Find org-roam note |

---

## Validation

```sh
emacs --batch -l ~/.emacs.d/init.el --eval '(message "emacs config loaded")'
```

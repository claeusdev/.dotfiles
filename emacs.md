# Emacs Setup

**Package manager**: use-package (MELPA, GNU ELPA, NonGNU ELPA)
**LSP client**: Eglot (built-in, Emacs 29+)
**Theme**: modus-operandi
**Config**: `~/.emacs.d/`

---

## Structure

```
early-init.el            — pre-startup optimisations (GC, UI chrome)
init.el                  — entry point, loads modules
elisp/
  core/
    el-packages.el       — package archives + use-package bootstrap
    el-core.el           — editor defaults
    el-bindings.el       — global keybindings + REPL launcher
  plugins/
    el-theme.el          — appearance
    el-completion.el     — vertico, corfu, consult, embark
    el-git.el            — magit, diff-hl
    el-lsp.el            — eglot + server mappings
    el-languages.el      — per-language modes
    el-org.el            — org, org-roam, citar, org-noter
    el-latex.el          — auctex, pdf-tools, cdlatex
    el-tools.el          — projectile, avy, treemacs, vterm, apheleia
    el-dap.el            — dap-mode
```

---

## Packages

### Completion

| Package | Purpose |
| :--- | :--- |
| vertico | Vertical minibuffer completion |
| orderless | Flexible (space-separated) matching |
| marginalia | Rich annotations in minibuffer |
| consult | Enhanced search/navigation commands |
| embark + embark-consult | Context-action menu |
| corfu | In-buffer popup completion |
| cape | Extra completion-at-point sources |
| nerd-icons-completion / nerd-icons-corfu | Icons in completion UI |

### Appearance

| Package | Config |
| :--- | :--- |
| modus-themes | modus-operandi, italic + bold constructs |
| nerd-icons | Icon font |
| rainbow-delimiters | Coloured brackets in prog-mode |
| doom-modeline | Height 28, project-relative filenames |

### Git

| Package | Purpose |
| :--- | :--- |
| magit | Full git UI |
| diff-hl | Gutter diff indicators (prog-mode, dired) |

### LSP (Eglot)

Auto-started for: C/C++, OCaml, Haskell, SML, Racket, Nix, Coq, Rust, Python, TypeScript.

| Language | Server |
| :--- | :--- |
| C/C++ | clangd |
| OCaml | ocamllsp |
| Haskell | haskell-language-server-wrapper |
| SML | millet-ls |
| Racket | racket-langserver |
| Nix | nil |
| Coq | coq-lsp |
| Rust | rust-analyzer |

### Languages

| Language | Packages/Notes |
| :--- | :--- |
| C/C++ | c-ts-mode, 4-space indent |
| Python | python-ts-mode, ruff + ty via eglot |
| Rust | rust-ts-mode, rust-mode, format on save |
| OCaml | tuareg, merlin |
| Haskell | haskell-mode |
| SML | sml-mode, 2-space indent |
| Racket | racket-mode |
| Nix | nix-mode |
| Coq | proof-general |
| Lean 4 | lean4-mode (loaded if `lean` on PATH) |
| Agda | agda-mode (loaded via `agda-mode locate`) |
| Markdown | markdown-mode |
| YAML | yaml-mode |

### Org ecosystem

| Package | Purpose |
| :--- | :--- |
| org | Notes, tasks, babel |
| org-superstar | Pretty bullets |
| citar | Bibliography management (`~/org/references.bib`) |
| org-noter | PDF annotation |
| org-download | Drag-and-drop images → `~/org/images/` |
| org-present | Presentation mode |
| org-roam | Zettelkasten (`~/org/roam/`) |
| citar-org-roam | Bibliography ↔ roam bridge |

**Todo states**: `TODO` → `NEXT` → `WAIT` → `DONE` / `CANCELLED`

**Capture templates**: Todo (`t`), Idea (`i`), Paper (`p`), Journal (`j`)

**Babel languages**: emacs-lisp, python, shell, latex

### LaTeX

| Package | Notes |
| :--- | :--- |
| auctex | PDF mode, source correlation, parse on save |
| pdf-tools | In-buffer PDF viewer |
| cdlatex | Fast math/environment insertion |

PDF viewer: Zathura (Linux), Skim (macOS).

### Development tools

| Package | Purpose |
| :--- | :--- |
| projectile | Project management (`~/projects/`, `~/src/`) |
| avy | Jump to visible text |
| smartparens | Balanced pair editing (strict in prog-mode) |
| yasnippet + yasnippet-snippets | Code snippets |
| which-key | Keybinding popup (0.3s delay) |
| treemacs + treemacs-projectile | File tree |
| vterm | Terminal (10k scrollback) |
| apheleia | Auto-format on save |
| wgrep | Editable grep/ripgrep results |
| editorconfig | Honour `.editorconfig` files |
| olivetti | Centred writing mode (90-char body) |
| jinx | Fast spell-check |
| writegood-mode | Prose quality hints |

---

## Key Options

| Setting | Value |
| :--- | :--- |
| Tabs | spaces, width 2 |
| Fill column | 100 |
| Line numbers | relative, in prog-mode |
| Scroll margin | 3 lines |
| Clipboard | system (`select-enable-clipboard`) |
| Backup / lockfiles | disabled |
| Auto-revert | enabled globally |
| Bell | silent |
| Yes/no prompts | `y`/`n` |

---

## Keybindings

### General

| Key | Action |
| :--- | :--- |
| `ESC` | Keyboard escape/quit |
| `M-o` | Other window |
| `C-c w` | Delete window |
| `C-c r` | Replace string |
| `C-x C-s` | Save file |
| `C-x C-f` | Find file |
| `C-g` | Cancel current operation |

### Search & Navigation

| Key | Action |
| :--- | :--- |
| `M-s l` | Consult line search |
| `M-s r` | Consult ripgrep |
| `M-s f` | Consult find file |
| `M-y` | Consult yank (kill ring) |
| `M-g g` | Go to line |
| `M-g i` | Consult imenu |
| `C-x b` | Switch buffer |
| `C-c j` | Avy jump to character |
| `C-x t t` | Toggle Treemacs |
| `M-0` | Select Treemacs window |
| `M-$` | Jinx spell-correct |

### Embark (context actions)

| Key | Action |
| :--- | :--- |
| `C-.` | Embark act |
| `M-.` | Embark dwim |
| `C-h B` | Show all bindings |

### Projectile — prefix `C-c p`

| Key | Action |
| :--- | :--- |
| `C-c p f` | Find file in project |
| `C-c p p` | Switch project |
| `C-c p s` | Search in project |
| `C-c p c` | Compile project |
| `C-c p k` | Kill project buffers |
| `C-c p h` | Projectile help |

### LSP — Eglot, prefix `C-c l`

| Key | Action |
| :--- | :--- |
| `C-c l a` | Code actions |
| `C-c l d` | Find definition |
| `C-c l D` | Find references |
| `C-c l f` | Format buffer |
| `C-c l r` | Rename symbol |
| `C-c l i` | Find implementation |
| `C-c l t` | Find type definition |
| `M-.` | Go to definition |
| `M-,` | Pop back |

### Git

| Key | Action |
| :--- | :--- |
| `C-x g` | Magit status |

`diff-hl` shows gutter indicators in prog-mode and dired. Press `?` in Magit for all commands.

### Debugging — DAP, prefix `C-c d`

| Key | Action |
| :--- | :--- |
| `C-c d b` | Toggle breakpoint |
| `C-c d d` | Start debug session |
| `C-c d n` | Step over |
| `C-c d c` | Continue |
| `C-c d s` | Step into |
| `C-c d o` | Step out |
| `C-c d r` | Restart |
| `C-c d q` | Disconnect |

### Completion

**Vertico** (minibuffer): `C-n`/`C-p` navigate, `RET` select.

**Corfu** (in-buffer): auto-triggers after 2 chars, `C-n`/`C-p` navigate, `RET` accept, `C-g` cancel.

### FP / Research REPLs — prefix `C-c f`

| Key | REPL |
| :--- | :--- |
| `C-c f h` | Haskell (ghci) |
| `C-c f o` | OCaml (utop) |
| `C-c f s` | SML |
| `C-c f r` | Racket |
| `C-c f l` | Common Lisp (sly/sbcl) |
| `C-c f e` | Emacs Lisp (ielm) |
| `C-c f n` | Lean 4 |
| `C-c f c` | Coq (Proof General) |
| `C-c f a` | Agda |

### Org Mode

| Key | Action |
| :--- | :--- |
| `C-c a` | Org agenda |
| `C-c c` | Org capture |
| `C-c C-c` | Execute babel block |

### Org Citations — Citar

| Key | Action |
| :--- | :--- |
| `C-c b o` | Open reference |
| `C-c b i` | Insert citation |
| `C-c b n` | Open citation notes |

### Org-noter

| Key | Action |
| :--- | :--- |
| `C-c N` | Start org-noter |

### Org-roam — prefix `C-c n`

| Key | Action |
| :--- | :--- |
| `C-c n f` | Find node |
| `C-c n i` | Insert node link |
| `C-c n b` | Toggle backlinks buffer |
| `C-c n c` | Capture to node |
| `C-c n d` | Go to today's daily |

### Which-key

Wait 0.3s after any prefix (`C-c`, `C-x`, `C-c p`, …) to see a popup of all available completions.

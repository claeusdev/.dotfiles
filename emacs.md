# Emacs Setup

**Package manager**: use-package (MELPA, GNU ELPA, NonGNU ELPA)
**LSP client**: Eglot (built-in, Emacs 29+)
**Theme**: modus-operandi
**Config**: `~/.emacs.d/`
**Project layer**: built-in `project.el`
**Health check**: `C-c e h`

---

## Structure

```
early-init.el            — pre-startup optimisations (GC, UI chrome)
init.el                  — entry point, loads modules
elisp/
  core/
    el-packages.el       — package archives + use-package bootstrap
    el-core.el           — editor defaults, session files, project switch UI
    el-bindings.el       — global keybindings + REPL launcher
  plugins/
    el-theme.el          — appearance
    el-completion.el     — vertico, corfu, consult, embark
    el-git.el            — magit, diff-hl
    el-lsp.el            — eglot + server mappings
    el-languages.el      — per-language modes
    el-org.el            — org, org-roam, citar, org-noter
    el-latex.el          — auctex, pdf-tools, cdlatex
    el-tools.el          — project.el workflow, avy, treemacs, vterm, apheleia
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
| corfu-history / corfu-popupinfo | Better ranking memory and popup documentation |
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

Auto-started for: C/C++, OCaml, Haskell, SML, Racket, Nix, Coq, Rust, Python.

| Language | Server |
| :--- | :--- |
| Python | `ty` when installed via `eglot-python-preset` |
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
| C/C++ | c-ts-mode when available, `cmake --build build` compile default, `ctest` test flow, clangd |
| Python | python-ts-mode, project `.venv` detection, current-file run command, pytest-oriented test command, ruff + ty via eglot |
| Rust | rust-ts-mode, rust-mode, `cargo check` compile default, `cargo test` test flow, rust-analyzer |
| OCaml | tuareg, dune build/test defaults, ocamllsp first, merlin fallback |
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

**Capture templates**: Todo (`t`), Idea (`i`), Project task (`p`), Paper (`R`), Journal (`j`)

**Bootstrap files**: `~/org/inbox.org`, `~/org/projects.org`, `~/org/papers.org`, `~/org/journal.org` are created automatically if missing, along with `~/org/roam/`, `~/org/pdfs/`, and `~/org/images/`.

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
| project.el | Built-in project management |
| avy | Jump to visible text |
| smartparens | Balanced pair editing (strict only in Lisp-like modes) |
| yasnippet + yasnippet-snippets | Code snippets |
| which-key | Keybinding popup (0.3s delay) |
| treemacs | File tree |
| vterm | Terminal (10k scrollback) |
| apheleia | Auto-format on save for Python, Rust, C/C++, Nix |
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
| Python fill column | 88 |
| Line numbers | relative, in prog-mode |
| Scroll margin | 3 lines |
| Clipboard | system (`select-enable-clipboard`) |
| Backups | enabled, stored under `~/.emacs.d/var/backup/` |
| Auto-save | enabled, stored under `~/.emacs.d/var/auto-save/` |
| Auto-revert | enabled globally |
| Bell | silent |
| Yes/no prompts | `y`/`n` |
| Local machine overrides | `local-pre.el`, `local-post.el` |

## Portability

Machine-specific overrides belong in:

- `~/.emacs.d/local-pre.el`
- `~/.emacs.d/local-post.el`

Example templates are shipped in:

- `~/.emacs.d/local-pre.el.example`
- `~/.emacs.d/local-post.el.example`

Use `local-pre.el` for early settings such as fonts or PATH tweaks.
Use `local-post.el` for settings that depend on packages already being loaded.

### Health check

Run:

- `C-c e h`

This opens a buffer that reports required and optional external tools, plus whether your local override files are present.

On a fresh machine, run this before debugging missing language servers, terminals, or PDF tooling.

### Required external tools

- `git`
- `rg`
- `python3`

### Common optional tools

- `ty` for Python LSP
- `rust-analyzer`
- `clangd`
- `ocamllsp`
- `haskell-language-server-wrapper`
- `millet-ls`
- `racket-langserver`
- `nil`
- `coq-lsp`
- `zathura` or `skim`

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
| `C-x C-s` | Save file |
| `C-x C-f` | Find file |
| `C-g` | Cancel current operation |

### Search & Navigation

| Key | Action |
| :--- | :--- |
| `C-c s l` | Search current buffer |
| `C-c s s` | Search current project |
| `C-c s r` | General ripgrep |
| `C-c s i` | Consult imenu |
| `C-c s o` | Consult outline |
| `M-y` | Consult yank (kill ring) |
| `M-g g` | Go to line |
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

### Projects — prefix `C-c p`

| Key | Action |
| :--- | :--- |
| `C-c p p` | Switch project |
| `C-c p P` | Switch project and find a file |
| `C-c p a` | Remember current directory as a project |
| `C-c p f` | Find file in project |
| `C-c p b` | Switch to project buffer |
| `C-c p d` | Find directory in project |
| `C-c p D` | Open project-root Dired |
| `C-c p o` | Open current project root in Dired |
| `C-c p O` | Switch project and open project-root Dired |
| `C-c p s` | Search project |
| `C-c p t` | Run project tests |
| `C-c p m` | Compile/build project |
| `C-c p v` | Open project vterm |
| `C-c p V` | Switch project and open project vterm |

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
| `C-c l e` | Show buffer diagnostics |
| `C-c l n` | Next diagnostic |
| `C-c l p` | Previous diagnostic |
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

**Corfu** (in-buffer): auto-triggers after 2 chars, `TAB` / `S-TAB` move through suggestions, `RET` accepts, `C-<tab>` or `C-M-i` triggers completion manually, `M-d` toggles popup docs when available.

**CAPF behavior**:

- programming modes keep language-specific completion first and add file/dabbrev as fallback
- text modes use lightweight dabbrev + file completion
- Eglot-managed buffers use orderless + basic matching for symbol completion
- active Yasnippet fields take priority over Corfu on `TAB` / `S-TAB`, so snippet navigation does not fight the popup

### Project entry points

Use these as the default project workflow:

- Start Emacs anywhere and jump into a known project file with `C-c p P`
- Switch projects with `C-c p p`
- Browse the current project root with `C-c p D`
- Browse any directory with built-in Dired via `C-x d`
- Use `C-x t t` only when you specifically want a persistent tree view

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
| `C-c n i` | Open inbox |
| `C-c n p` | Open projects |
| `C-c n P` | Open papers |
| `C-c n j` | Open journal |
| `C-c n s` | Search notes |
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
| `C-c n I` | Insert node link |
| `C-c n i` | Open inbox |
| `C-c n p` | Open projects file |
| `C-c n P` | Open papers file |
| `C-c n j` | Open journal file |
| `C-c n b` | Toggle backlinks buffer |
| `C-c n c` | Capture to node |
| `C-c n d` | Go to today's daily |
| `C-c n l` | Find literature note |
| `C-c n s` | Search org and roam files |

### Which-key

Wait 0.3s after any prefix (`C-c`, `C-x`, `C-c p`, …) to see a popup of all available completions.

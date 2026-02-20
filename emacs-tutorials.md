# Emacs Tutorials

## Keybindings Quick Start

This guide explains the keybindings configured in this repository and what they do.

## Core Editing and Navigation

- `Esc`: Cancel prompt / quit transient UI (`keyboard-escape-quit`).
- `M-o`: Move to next window.
- `C-c w`: Close current window.
- `C-c r`: Run `replace-string`.

## Search and Navigation

- `M-s l`: `consult-line` — search in current buffer.
- `M-s r`: `consult-ripgrep` — search across project files.
- `M-s f`: `consult-find` — find file by name.
- `M-y`: `consult-yank-pop` — browse kill-ring.
- `M-g g`: `consult-goto-line` — jump to line number.
- `M-g i`: `consult-imenu` — jump to symbol in buffer.
- `C-x b`: `consult-buffer` — switch buffer with preview.
- `C-.`: Embark actions on thing at point.
- `M-.`: Embark dwim (do what I mean).
- `C-h B`: Show all embark bindings.
- `C-c j`: Avy jump to character.
- `M-$`: Jinx spell-correct word at point.

## Project Management (Projectile)

- `C-c p`: Projectile command map (project switching, file search, grep).

## LSP (Eglot)

In buffers where `eglot` is active:

- `C-c l a`: Code actions
- `C-c l d`: Find definitions (`xref-find-definitions`)
- `C-c l D`: Find references (`xref-find-references`)
- `C-c l f`: Format buffer
- `C-c l r`: Rename symbol
- `C-c l i`: Find implementation
- `C-c l t`: Find type definition

## Git

- `C-x g`: Open Magit status.

`diff-hl` shows change indicators in the gutter for `prog-mode` and `dired-mode` buffers.

## Debugging (DAP Mode)

- `C-c d b`: Toggle breakpoint
- `C-c d d`: Start debugging
- `C-c d n`: Next (step over)
- `C-c d c`: Continue
- `C-c d s`: Step in
- `C-c d o`: Step out
- `C-c d r`: Restart debug session
- `C-c d q`: Disconnect

## Research and Writing (Org + Citar)

- `C-c a`: Open agenda
- `C-c c`: Capture (todo/idea/paper/journal templates)
- `C-c C-c`: Execute babel source block
- `C-c b i`: Insert citation (`citar`)
- `C-c b o`: Open reference entry
- `C-c b n`: Open citation notes
- `C-c N`: Org-noter (PDF annotation alongside org notes)

### Org-roam (Zettelkasten)

- `C-c n f`: Find node
- `C-c n i`: Insert node link
- `C-c n b`: Toggle backlinks buffer
- `C-c n c`: Capture to node
- `C-c n d`: Daily note (today)

Recommended structure:
- `~/org/inbox.org`, `projects.org`, `research.org`, `reading.org`, `journal.org`
- `~/org/references.bib`
- `~/org/papers/`

## Functional Programming REPL Layer (`C-c f`)

- `C-c f h`: Haskell REPL (`haskell-interactive-switch` / `ghci`)
- `C-c f o`: OCaml REPL (`utop`)
- `C-c f s`: SML REPL (`sml-run` / `sml`)
- `C-c f r`: Racket REPL (`racket-repl` / `racket`)
- `C-c f l`: Common Lisp REPL (`sly` / `sbcl`)
- `C-c f e`: Emacs Lisp REPL (`ielm`)
- `C-c f n`: Lean 4 REPL (`lean4-repl`)
- `C-c f c`: Coq proof (`proof-shell-start`)
- `C-c f a`: Agda type-check/load (`agda2-mode`)

Typical OCaml loop:
1. Open `.ml` file.
2. `C-c f o` to start REPL.
3. Edit code, then re-run `C-c f o` to reload.

Typical paper-note loop:
1. `C-c c` then select `p` (paper note).
2. In notes, `C-c b i` to insert citations.

## Agda Mode Setup

Your config auto-loads Agda mode by running `agda-mode locate` at startup.

Requirements:
- `agda` and `agda-mode` installed and on `PATH`.
- Typical install path from Haskell tooling (`cabal`): `~/.cabal/bin/agda-mode`.

Common install commands:
- `cabal install Agda`
- Then verify: `agda-mode locate`

File extensions enabled:
- `.agda`
- `.lagda`
- `.lagda.md`

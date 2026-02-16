# Emacs Tutorials

## Keybindings Quick Start

This guide explains the keybindings configured in this repository and what they do.

## Core Editing and Navigation

- `C-\``: Toggle terminal (`vterm`) in the current window layout.
- `Esc`: Cancel prompt / quit transient UI (`keyboard-escape-quit`).
- `M-o`: Move to next window.
- `C-c w`: Close current window.
- `C-c r`: Run `replace-string`.
- `C-z`: Undo (`undo-tree-undo`).
- `C-S-z`: Redo (`undo-tree-redo`).

## Project and Search

- `C-x g`: Open Magit status.
- `C-c p`: Projectile command map (project switching, file search, grep).
- `M-s`: `consult-line` in current buffer.
- `M-y`: `consult-yank-pop` (kill-ring browse).
- `C-x b`: `consult-buffer`.
- `C-.`: Embark actions on thing at point.

## LSP (Programming Buffers with Eglot)

In buffers where `eglot` is active:

- `C-c l a`: Code actions
- `C-c l f`: Format buffer
- `C-c l r`: Rename symbol
- `C-c l d`: Go to declaration
- `C-c l i`: Go to implementation
- `C-c l t`: Go to type definition
- `C-c l s`: Workspace symbols (`consult-eglot-symbols`)

## Research and Writing (Org + Citar)

- `C-c a`: Open agenda
- `C-c c`: Capture (todo/idea/paper/journal templates)
- `C-c l`: Store link
- `C-c b i`: Insert citation (`citar`)
- `C-c b o`: Open reference entry
- `C-c b n`: Open citation notes
- `C-c b a`: Add PDF/file to citation library

Recommended structure:
- `~/org/inbox.org`, `projects.org`, `research.org`, `reading.org`, `journal.org`
- `~/org/references.bib`
- `~/org/papers/`

## Functional Programming REPL Layer (`C-c f`)

- `C-c f h`: Open Haskell REPL
- `C-c f H`: Load current Haskell file into REPL
- `C-c f o`: Open OCaml REPL (`utop`/`ocaml`)
- `C-c f O`: Load current OCaml file into REPL
- `C-c f r`: Open Racket REPL
- `C-c f e`: Open Elixir REPL (`iex`)

Typical OCaml loop:
1. Open `.ml` file.
2. `C-c f o` to start REPL.
3. `C-c f O` after edits to reload.

Typical paper-note loop:
1. `C-c b a` to attach paper.
2. `C-c c` then select `p` (paper note).
3. In notes, `C-c b i` to insert citations.

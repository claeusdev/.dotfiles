# Emacs Setup

**Package manager**: use-package
**LSP client**: Eglot
**Theme**: Modus Operandi (light), toggle to Vivendi with `C-c t t`
**Config**: `~/.emacs.d/`
**Project layer**: built-in `project.el`
**Notes**: Denote
**Health check**: `C-c e h`

---

A small, modern Emacs 30 configuration for software engineering and research:
roughly 550 lines across six modules, with 30 packages. Everything Emacs now
does well enough on its own — projects, LSP, diagnostics, tree-sitter,
which-key, editorconfig — is used from the built-ins rather than replaced.

Run `C-c e h` on a new machine. It reports every external tool the config
expects and is the fastest way to find a missing language server.

## Structure

```text
~/.emacs.d/
  early-init.el        GC, UI chrome, native-comp guard
  init.el              package bootstrap, ordered module loading
  elisp/
    core.el            editor defaults, session, theme, fonts, health check
    completion.el      vertico, orderless, marginalia, consult, embark, corfu, cape
    dev.el             project, eglot, apheleia, magit, forge, diff-hl, vterm, dape
    langs.el           tree-sitter grammars and per-language setup
    notes.el           org, denote, org-modern, olivetti, jinx, org-present, gptel
    keys.el            every global binding, loaded last
  custom.el            machine-local; holds package-selected-packages
  local-pre.el         optional, loaded before modules; untracked
  local-post.el        optional, loaded after modules; untracked
```

Modules load in dependency order. `keys.el` is last so every map it binds
into already exists.

## Philosophy

- **Built-ins first.** `project.el` over projectile, `eglot` over lsp-mode,
  `flymake` over flycheck, tree-sitter modes over hand-written ones.
- **Nothing configured that is not used.** No language, note system, or tool
  appears here unless it is part of the actual workflow.
- **Fail visibly, not silently.** Language servers start only when their
  binary exists (`my/eglot-ensure-when-executable`), and `C-c e h` names what
  is missing instead of leaving a mode quietly broken.
- **One prefix per concern.** `C-c p` projects, `C-c s` search, `C-c l` LSP,
  `C-c n` notes, `C-c d` debug, `C-c f` REPLs, `C-c t` toggles, `C-c e` Emacs.

## Language support

| Language | Mode | LSP | Formatter |
| :--- | :--- | :--- | :--- |
| TypeScript | `typescript-ts-mode` | vtsls | prettier |
| React / TSX | `tsx-ts-mode` | vtsls | prettier |
| JavaScript | `js-ts-mode` | vtsls | prettier |
| Rust | `rust-ts-mode` | rust-analyzer | rustfmt |
| OCaml | `tuareg-mode` | ocamllsp | ocamlformat |
| Python | `python-ts-mode` | basedpyright | ruff |
| SQL | `sql-mode` | — | sql-formatter |
| YAML | `yaml-ts-mode` | yaml-language-server | prettier |
| Dockerfile | `dockerfile-ts-mode` | docker-langserver | — |
| JSON / TOML | `json-ts-mode`, `toml-ts-mode` | — | prettier |
| Markdown | `markdown-mode` | — | prettier |

Emacs ships tree-sitter support but no grammars. Install them once with
`C-c e g` (`my/install-missing-grammars`); they compile into
`~/.emacs.d/tree-sitter/`.

Formatting runs on save through Apheleia, asynchronously, without moving
point.

## Key packages

- **Completion** — vertico, orderless, marginalia, consult, embark,
  embark-consult, corfu, cape
- **Git** — magit, forge, diff-hl
- **Development** — apheleia, wgrep, vterm, dape
- **Appearance** — modus-themes, doom-modeline, nerd-icons (plus completion
  and corfu variants), rainbow-delimiters
- **Languages** — tuareg, markdown-mode
- **Notes and writing** — denote, org-modern, olivetti, jinx, org-present
- **Research** — gptel

`package-selected-packages` in `custom.el` is kept in sync with the
`use-package` declarations, which is what makes `M-x package-autoremove` safe
to run.

## Keybindings

### General

| Key | Action |
| :--- | :--- |
| `M-o` | Other window |
| `C-c w` | Delete window |
| `C-x b` | Switch buffer (consult) |
| `M-y` | Yank history |
| `C-.` | Embark act |
| `C-h B` | Every binding in this buffer |
| `<escape>` | Quit / cancel |

### Search — `C-c s`

| Key | Action |
| :--- | :--- |
| `C-c s s` | Ripgrep the project |
| `C-c s r` | Ripgrep, prompting for a directory |
| `C-c s l` | Search lines in this buffer |
| `C-c s i` | Jump to a symbol (imenu) |
| `C-c s o` | Jump by outline heading |

`M-g g` goto-line, `M-g i` imenu and `M-g o` outline are bound directly too.

### Projects — `C-c p`

| Key | Action |
| :--- | :--- |
| `C-c p p` | Switch project |
| `C-c p P` | Switch project and find a file |
| `C-c p f` | Find file in project |
| `C-c p b` | Switch buffer in project |
| `C-c p a` | Remember this directory as a project |
| `C-c p d` / `D` | Find directory / Dired |
| `C-c p o` | Dired at project root |
| `C-c p m` | Compile |
| `C-c p t` | Test (mode-aware) |
| `C-c p v` | vterm at project root |

`C-c p t` picks its command from the major mode: the project's npm, pnpm,
yarn or bun `test` script for TS and JS, else `cargo test`, `dune test`, or
pytest.

### LSP — `C-c l`

| Key | Action |
| :--- | :--- |
| `C-c l d` | Go to definition |
| `C-c l D` | Find references |
| `C-c l i` | Find implementation |
| `C-c l t` | Find type definition |
| `C-c l r` | Rename across the project |
| `C-c l a` | Code actions |
| `C-c l f` | Format buffer |
| `C-c l e` | Buffer diagnostics |
| `C-c l n` / `p` | Next / previous error |

`M-g n` and `M-g p` also move between diagnostics.

### Git — `C-x g`

| Key | Action |
| :--- | :--- |
| `C-x g` | Magit status |
| `s` / `u` | Stage / unstage (file, hunk, or region) |
| `c c` | Commit — `C-c C-c` to finish |
| `b b` / `b c` | Checkout / create branch |
| `P p` / `F p` | Push / pull |
| `'` | Forge: pull requests and issues |
| `?` | Full menu for the current context |

Forge authenticates with the same token as `gh`. diff-hl marks changed lines
in the fringe as you type.

### Debugging — `C-c d`

| Key | Action |
| :--- | :--- |
| `C-c d d` | Start dape |
| `C-c d b` | Toggle breakpoint |
| `C-c d n` / `i` / `o` | Next / step in / step out |
| `C-c d c` | Continue |
| `C-c d q` | Quit |

Adapters: `debugpy` for Python, `lldb-dap` for Rust and native code.

### Notes — `C-c n`

| Key | Action |
| :--- | :--- |
| `C-c n n` | New Denote note |
| `C-c n l` | Insert a link to another note |
| `C-c n b` | Backlinks |
| `C-c n r` | Rename / retag |
| `C-c n f` | Find a note |
| `C-c n s` | Ripgrep all notes |
| `C-c n i` / `p` / `j` | Inbox / projects / journal |
| `C-c c` | Org capture |
| `C-c a` | Org agenda (`C-c a d` for the dashboard) |

### Toggles, Emacs, LLM, REPLs

| Key | Action |
| :--- | :--- |
| `C-c t t` | Light / dark theme |
| `C-c t l` / `w` / `o` | Line numbers / visual line / olivetti |
| `C-c e h` | Health check |
| `C-c e g` | Install missing tree-sitter grammars |
| `C-c g` / `C-c G` | gptel: send region / open chat |
| `C-c f o` `p` `n` `s` `e` | REPL: OCaml, Python, Node, SQL, elisp |
| `M-$` | Correct spelling at point |

Pause after any prefix and which-key lists what follows.

## External tools

Required: `git`, `rg`, `node`.

Expected but optional: `vtsls`, `rust-analyzer`, `ocamllsp`,
`basedpyright-langserver`, `yaml-language-server`, `docker-langserver`,
`ruff`, `prettier`, `sql-formatter`, `ocamlformat`, `debugpy`, `lldb-dap`,
`gh`, `enchant`, `fd`.

```sh
npm install -g vtsls basedpyright yaml-language-server \
               dockerfile-language-server-nodejs sql-formatter prettier
rustup component add rust-analyzer          # the rustup shim alone is not enough
opam install ocaml-lsp-server ocamlformat
brew install enchant                        # jinx will not build without it
uv tool install debugpy
ln -sf "$(xcrun --find lldb-dap)" ~/.local/bin/lldb-dap
```

`gptel` reads its key from `~/.authinfo.gpg`, never from the environment, so
it cannot leak into this repo:

```
machine api.anthropic.com login apikey password sk-ant-...
```

## Validation

```sh
emacs --batch -l ~/.emacs.d/init.el --eval '(princ "ok")'   # starts clean
emacs --batch --eval '(byte-recompile-directory "~/.emacs.d/elisp" 0 t)'
/usr/bin/time -p emacs --batch -l ~/.emacs.d/init.el --eval '(princ "")'
```

Startup is about 0.27s. Delete any `.elc` files afterwards — a stale `.elc`
shadowing a chezmoi-updated `.el` is a real hazard.

In `--batch`, flymake's timers never run, so `flymake-diagnostics` reports
nothing even when the server has answered. Inspect `eglot--diagnostics`
instead when testing non-interactively.

## Troubleshooting

### "Vertico detected an error" in the minibuffer

Vertico catches errors raised by annotators and reports them, so the name in
the message is rarely the culprit. Read the backtrace from the top: the first
few frames name the real offender.

The known instance of this is a **`compat` miscompilation**. If the backtrace
shows

```
vertico--debug((wrong-number-of-arguments (1 . 1) 3))
seconds-to-string(... expanded abbrev)
marginalia--time-relative(...)
```

then `marginalia.el` was byte-compiled at install time in an environment where
`compat-31` was not loaded. The `compat-call` macro then expanded to the
*native* `seconds-to-string` (which takes one argument on Emacs 30) instead of
`compat--seconds-to-string` (which takes four). The wrong call is baked into
the `.elc`, so it survives restarts.

Fix by recompiling the package with compat present:

```sh
emacs --batch --eval "(progn (package-initialize) (require 'compat) \
  (require 'compat-31 nil t) \
  (byte-compile-file \"~/.emacs.d/elpa/marginalia-*/marginalia.el\"))"
```

Or from inside Emacs, `M-x package-recompile RET marginalia RET`.
`M-x package-recompile-all` fixes the whole tree if more than one package is
affected.

To check whether any other package is exposed to the same failure, compare
each `compat-call` site's argument count against the native function's arity —
only calls that pass *more* arguments than the native function accepts can
break this way.

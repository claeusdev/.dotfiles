# Emacs — Getting Started (Hands-On)

A do-along lesson for *this* configuration: a deliberately small, keyboard-driven
setup for **note-taking, research, and software engineering**. Open Emacs, keep a
real project handy, and work through each section — every one ends with a short
**Practice**.

The single most important key: **`C-g`** (cancel). If you ever feel stuck or lost,
press `C-g` (or `ESC`) and you are back to safety. Nothing here can break anything
a `C-g` and a save won't fix.

---

## How to read the keys

- `C-x` = hold **Control**, press `x`. `M-x` = hold **Meta** (`Alt` / `⌥`), press `x`. `S-` = **Shift**.
- `C-c p f` is a sequence: `Control-c`, then `p`, then `f`.
- Any command can also be run by name with **`M-x`** — the prefixes below are just fast paths.
- **You do not have to memorize anything.** Press a prefix (e.g. `C-c p`) and *pause* —
  `which-key` pops up showing every next key. Discovery beats memory.

> **Practice** — Press `C-c` and wait one second. Read the popup. Dismiss it with `C-g`.

---

## 0. The shape of this config

Almost everything hangs off seven prefixes. Learn these and you can find the rest by waiting for `which-key`:

| Prefix          | Domain                                                     |
| :-------------- | :--------------------------------------------------------- |
| `C-c p`         | **Project** — find files, search, compile, test, shell     |
| `C-c l`         | **LSP** — definitions, references, rename (in code only)    |
| `C-c s`         | **Search** & navigation                                    |
| `C-c n`         | **Notes** & research (org-roam)                            |
| `C-c c` / `C-c a` | **Capture** / **Agenda**                                 |
| `C-c f`         | Language **REPLs** (Haskell `h`, OCaml `o`, Elisp `e`)      |
| `C-x g`         | **Magit** (git)                                            |

Run a **health check** any time with `C-c e h` — it lists which external tools
(ripgrep, language servers, formatters) are actually installed.

> **Practice** — Run `C-c e h`. Note anything marked `missing`; that's a tool to install later. Press `q` to close.

---

## 1. Files, buffers, windows

| Key       | Action                                  |
| :-------- | :-------------------------------------- |
| `C-x C-f` | Open / create a file                    |
| `C-x C-s` | Save                                    |
| `C-x b`   | Switch buffer (with preview + recents)  |
| `C-x k`   | Kill (close) a buffer                   |
| `C-x 2` / `C-x 3` | Split below / split right       |
| `C-x 1` / `C-x 0` | Keep only this window / close it |
| `M-o`     | Jump to the other window                |
| `C-c w`   | Delete the current window               |
| `C-/`     | Undo (`C-?` to redo)                    |

Code buffers get relative line numbers and a fill-column rule; prose buffers soft-wrap.

> **Practice** — `C-x C-f` open a file, `C-x 3` to split right, `M-o` to hop between panes, `C-x 1` to collapse back to one.

---

## 2. Moving inside a file

| Key            | Action                                            |
| :------------- | :------------------------------------------------ |
| `C-c j`        | **Avy** — type a char, then its highlight, to jump |
| `C-c s l`      | Search lines in this buffer (jump on `RET`)       |
| `M-g i`        | Jump to a function / heading (imenu)              |
| `M-g o`        | Jump by outline                                   |
| `M-g g`        | Go to line number                                 |

The classic motions still apply: `C-n`/`C-p` line, `C-f`/`C-b` char, `M-f`/`M-b` word,
`C-a`/`C-e` line ends, `M-<`/`M->` buffer ends.

> **Practice** — `C-c s l`, type a word that's on screen, `RET` to land on it. Then `C-c j` and teleport to any visible character.

---

## 3. Working across a project

A **project** is a git repo, or any folder with a `pyproject.toml`, `Cargo.toml`,
`.envrc`, or `compile_commands.json`. Open any file inside one and Emacs treats the
whole tree as the project.

| Key       | Action                                        |
| :-------- | :-------------------------------------------- |
| `C-c p p` | Switch to / open a project                    |
| `C-c p f` | Find a file by name (fuzzy)                   |
| `C-c p b` | Switch between this project's buffers         |
| `C-c p s` | Search the project (ripgrep)                  |
| `C-c s r` | Ripgrep starting from a chosen folder         |
| `C-c p D` | Dired (file manager) at the project root      |
| `C-c p a` | Remember the current folder as a project      |

Search results are a live list — `RET` jumps to a hit. For **project-wide
find-and-replace**, run a ripgrep search, press `C-.` (Embark) → *export* to a grep
buffer, edit the matches like ordinary text (`wgrep`), then save to apply across files.

> **Practice** — `C-c p f` and type part of a filename to open it. Then `C-c p s`, search for a symbol, and `RET` into a result.

---

## 4. Completion and editing

As you type code, **Corfu** shows suggestions automatically:

- `TAB` cycles candidates, `RET` inserts, `C-g` dismisses (`C-n`/`C-p` also move).
- `TAB` is context-aware: at the start of a line it indents; mid-word it completes.
- **Cape** adds file-path and in-buffer-word completion on top.

Brackets and quotes auto-close (electric-pair), and matching parens are highlighted.

**Formatting is automatic.** Every time you save (`C-x C-s`), Apheleia reformats with
the right tool for the language — `ruff`, `rustfmt`, `clang-format`, `prettier`,
`sql-formatter`, etc. You never format by hand (though `C-c l f` does it on demand).

> **Practice** — In a code buffer, start typing an identifier; when the popup appears, `TAB` to a candidate, `RET`. Then `C-x C-s` and watch the file reformat.

---

## 5. The code loop: LSP, compile, test

Open a file in a project whose **language server is installed** and `eglot` starts
automatically (the modeline changes to show it). Use `C-c e h` to see which servers
you have.

Intelligence lives under `C-c l`:

| Key       | Action                          |
| :-------- | :------------------------------ |
| `C-c l d` | Go to definition (`M-,` returns) |
| `C-c l D` | Find references                 |
| `C-c l i` | Find implementation             |
| `C-c l t` | Find type definition            |
| `C-c l r` | Rename symbol everywhere        |
| `C-c l a` | Code actions (quick-fixes)      |
| `C-c l f` | Format buffer                   |
| `C-c l e` | List diagnostics                |
| `C-c l n` / `C-c l p` | Next / previous error |

Function signatures and docs appear in the echo area as you move (eldoc).

**Build and test from anywhere in the project:**

| Key       | Action                                                            |
| :-------- | :--------------------------------------------------------------- |
| `C-c p m` | Compile / build (remembers a per-language default to edit)       |
| `C-c p t` | Run tests (picks `pytest`, `cargo test`, `dune test`, `npm test`…) |
| `C-c p v` | Open a `vterm` shell at the project root                          |

> **Python note:** the config detects a `.venv`/`venv` (your uv workflow), and uses
> `ty` for the language server and `ruff` for formatting — no extra setup.

> **Practice** — Open a source file, put the cursor on a symbol, `C-c l d` to jump to its definition, `M-,` to jump back. Then `C-c p t` to run the suite.

---

## 6. Git with Magit

`C-x g` opens the status buffer — the whole git interface lives here:

| Key (in Magit) | Action                                  |
| :------------- | :-------------------------------------- |
| `TAB`          | Expand / collapse a diff                |
| `s` / `u`      | Stage / unstage the item at point       |
| `c c`          | Commit (write message, `C-c C-c` to confirm) |
| `P p`          | Push                                    |
| `F p`          | Pull                                    |
| `b b`          | Switch branch                           |
| `l l`          | Show log                                |
| `?`            | List **every** command                  |

Changed lines are marked in the gutter (diff-hl) as you edit.

> **Practice** — Make an edit, `C-x g`, stage it with `s`, commit with `c c`, type a message, `C-c C-c`.

---

## 7. Notes and tasks (org)

Four files live in `~/org/` (created automatically on first start): `inbox.org`,
`projects.org`, `papers.org`, `journal.org`.

**Capture** from anywhere with `C-c c`, then pick a template:

| Key | Captures…                  |
| :-- | :------------------------- |
| `t` | TODO → inbox               |
| `i` | Idea → inbox               |
| `p` | Project task → projects    |
| `R` | Paper to read → papers     |
| `j` | Journal entry              |

Finish a capture with `C-c C-c`, abort with `C-c C-k`.

**Review** with the agenda `C-c a`, then a view:

| Key | View                                           |
| :-- | :--------------------------------------------- |
| `d` | Dashboard (today + inbox + next + research/coding) |
| `r` | Research items                                 |
| `w` | Writing items                                  |
| `p` | Projects                                       |

In a heading, set state with `C-c C-t` (or cycle with `S-→`): **TODO → NEXT → WAIT →
DONE/CANCELLED**. Tag with `@research`, `@coding`, `@writing`, `@admin`. Quick file
access: `C-c n i` (inbox), `C-c n p` (projects), `C-c n j` (journal).

> **Practice** — `C-c c`, `t`, write a task, `C-c C-c`. Then `C-c a`, `d` to see it on the dashboard.

---

## 8. Research: org-roam + citations

**org-roam** is your linked note network (a Zettelkasten):

| Key       | Action                                             |
| :-------- | :------------------------------------------------- |
| `C-c n f` | Find or **create** a note (type a title)           |
| `C-c n I` | Insert a link to another note while writing        |
| `C-c n c` | Capture with a template: default / project / literature |
| `C-c n b` | Toggle the **backlinks** panel (what links here)   |
| `C-c n d` | Jump to today's daily note                         |
| `C-c n l` | Browse literature notes                            |
| `C-c n s` | Ripgrep across all notes                           |

**Citations (citar)** — keep references in `~/org/references.bib` and PDFs in
`~/org/pdfs/`. Inside an org buffer:

| Key       | Action                                   |
| :-------- | :--------------------------------------- |
| `C-c b i` | Insert a citation                        |
| `C-c b o` | Open the cited paper's PDF / link        |
| `C-c b n` | Open (or create) that paper's note       |
| `C-c N`   | **org-noter** — annotate a PDF page-by-page next to your notes |

Writing aids: org buffers open in a centered column (olivetti); `M-$` corrects the
word at point (jinx); clumsy phrasing is highlighted (writegood).

**A paper, end to end:** add it to `references.bib` → `C-c b n` to spin up its
literature note → read the PDF with `C-c N`, capturing notes against page locations →
`C-c n I` to link it into a project note → it now appears in that project's
**backlinks** (`C-c n b`).

> **Practice** — `C-c n f`, type `Test Note`, `RET` — you just created a roam note. Write a line, `C-c n I` to link another note, then `C-c n b` to see the backlink.

---

## 9. Discover, don't memorize

This config is built so you can *find* commands instead of recalling them:

- **which-key** — pause after any prefix to see all next keys.
- **Embark** (`C-.`) — act on the thing under the cursor *or* the highlighted
  completion candidate, like a context menu. `M-.` runs the most likely action;
  `C-h B` lists every active binding.
- **Built-in help** — `C-h k` then a key explains it; `C-h f` a function; `C-h m`
  this mode's keys; `C-h o` any symbol.

> **Practice** — Put the cursor on a file path or URL and press `C-.`. Pick an action from the menu.

---

## 10. When something feels broken

- **Stuck** in a prompt or half-typed chord: `C-g`, or `ESC`.
- **No completion / no formatting** for a language: run `C-c e h` and install whatever
  shows `missing` (a server or formatter).
- **See what just happened:** `C-x b` → `*Messages*`.
- **Confirm the whole config still loads:**
  ```sh
  emacs --batch -l ~/.emacs.d/init.el --eval '(message "ok")'
  ```
- **Machine-specific tweaks** (fonts, paths, secrets) go in `~/.emacs.d/local-pre.el`
  or `local-post.el` — both load automatically and are never committed to the dotfiles.

---

## One-page cheat sheet

| Want to…                  | Press                                  |
| :------------------------ | :------------------------------------- |
| Run any command by name   | `M-x`                                  |
| Cancel / get unstuck      | `C-g` / `ESC`                          |
| Open a file               | `C-x C-f`                              |
| Switch buffer             | `C-x b`                                |
| Find file in project      | `C-c p f`                              |
| Search project            | `C-c p s`                              |
| Jump on screen            | `C-c j`                                |
| Go to definition          | `C-c l d` (back: `M-,`)                |
| Rename symbol             | `C-c l r`                              |
| Compile / test            | `C-c p m` / `C-c p t`                  |
| Project shell             | `C-c p v`                              |
| Git                       | `C-x g`                                |
| Capture a note/task       | `C-c c`                                |
| Agenda                    | `C-c a`                                |
| Find/create roam note     | `C-c n f`                              |
| Insert note link          | `C-c n I`                              |
| Backlinks                 | `C-c n b`                              |
| Insert citation           | `C-c b i`                              |
| Spell-correct word        | `M-$`                                  |
| Health check              | `C-c e h`                              |

---

## Where to go next

- **[Emacs Development Workflow](emacs-dev-workflow.md)** — deeper on project navigation, the edit/build/test loop, and refactoring.
- **[Emacs Org Workflow](emacs-org-workflow.md)** — deeper on the notes, research, papers, and writing system.
- **[Emacs Setup Overview](emacs.md)** — the package/keybinding reference and per-language tooling.

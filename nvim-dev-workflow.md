# Neovim Development Workflow

This guide is a practical walkthrough for using the Neovim setup in this repository as a daily engineering environment.

It is written for this config, not for Neovim in general.

The setup is centered around a few ideas:

- Telescope is the main way to find files, symbols, and text.
- Oil is the main way to move around the filesystem.
- LSP is the main way to navigate code semantics.
- Neotest, Overseer, and DAP are the main execution tools.
- Git work happens directly in the editor with Gitsigns, LazyGit, and Diffview.

---

## 1. The mental model

Think of the editor as four loops.

### Read loop

- find a file with `<leader>ff` or `<leader>fp`
- jump to symbols with `<leader>fs`
- search across the repo with `<leader>fg`
- jump to definitions with `gd`
- return to broader search when needed

### Edit loop

- keep a few active files open
- move between them with `<leader>bn` and `<leader>bp`
- use `gcc`, `gc`, `gb`, surround, and Flash to edit quickly
- save often with `<C-s>`

### Execute loop

- run tests with `<leader>tt`, `<leader>tf`, or `<leader>oT`
- run project tasks with `<leader>or`, `<leader>os`, `<leader>ob`, and `<leader>on`
- debug with `<leader>td`, `<leader>dC`, and `<leader>dP`

### Review loop

- inspect hunks with `]h`, `[h`, and `<leader>gp`
- stage or reset with `<leader>gs` and `<leader>gr`
- open LazyGit with `<leader>gg`
- inspect file history with `<leader>gh`

If you keep those loops in mind, the config becomes much easier to use.

---

## 2. Open a project and get oriented

The fastest entry points are:

- `<leader>ff` for all files
- `<leader>fp` for Git-tracked files
- `<leader>fr` for recent files
- `-` to open Oil in the current directory

When you first open a repo, use this sequence:

1. `<leader>fp` to jump to a likely entry file.
2. `<leader>fg` to find an important symbol or concept.
3. `gd`, `gr`, and `gi` to move semantically once LSP is attached.
4. `<leader>ha` on the few files you know you will revisit.

That pattern is usually faster than opening a tree and clicking around.

---

## 3. Find things quickly

The most important Telescope keys are:

| Key | Use it for |
| :--- | :--- |
| `<leader>ff` | broad file search |
| `<leader>fp` | repo file search, especially in Git repos |
| `<leader>fr` | recently used files |
| `<leader>fg` | project-wide content search |
| `<leader>f/` | search just the current buffer |
| `<leader>f.` | resume your previous picker |
| `<leader>fs` | jump to symbols in the current file |
| `<leader>fS` | jump to workspace symbols |
| `<leader>fd` | search diagnostics |

Practical rule:

- if you know the filename, use `ff` or `fp`
- if you know the text, use `fg`
- if you know the function or class name, use `fs`
- if you just came from somewhere useful, use `f.`

---

## 4. Read and navigate code

Once LSP is attached, the core movement keys are:

| Key | Action |
| :--- | :--- |
| `gd` | definition |
| `gD` | declaration |
| `gr` | references |
| `gi` | implementation |
| `gt` | type definition |
| `K` | hover docs |

Useful supporting keys:

| Key | Action |
| :--- | :--- |
| `<leader>ld` | line diagnostics |
| `<leader>lh` | toggle inlay hints |
| `<leader>lc` | run code lens |
| `<leader>lC` | refresh code lens |
| `<leader>fs` | document symbols |
| `<leader>fS` | workspace symbols |

For structural movement inside a file:

- `af`, `if`, `ac`, `ic` for text objects
- `]f`, `[f`, `]c`, `[c` for function and class jumps
- `<leader><leader>` for Flash jump

This is the normal reading loop:

1. Use `<leader>fg` or `<leader>fs` to find the target.
2. Use `gd` or `gi` to descend.
3. Use buffer switching or Telescope resume to regain context.

---

## 5. Edit without losing flow

This config is tuned for low-friction edits.

Important keys:

| Key | Action |
| :--- | :--- |
| `<C-s>` | save |
| `gcc` | comment line |
| `gc` / `gb` | comment selection |
| `s` | Flash jump |
| `S` | Flash Treesitter |
| `<leader>u` | Undotree |
| `<leader>z` | Zen mode |

Practical habits:

- use Harpoon for the 3-5 files you bounce between constantly
- use `<leader>f/` before large edits to find local repetitions
- use Undotree when a refactor gets non-linear

---

## 6. Use language intelligence well

The LSP layer is strongest when you use it for concrete actions, not just hover.

Core code actions:

| Key | Action |
| :--- | :--- |
| `<leader>la` | generic code action |
| `<leader>lr` | rename symbol |
| `<leader>ci` | organize imports |
| `<leader>cI` | add missing imports |
| `<leader>cu` | remove unused imports |
| `<leader>cF` | fix all auto-fixable issues |

In practice:

- TypeScript and JavaScript benefit most from the `c...` import and fix keys.
- Rust and TypeScript benefit from inlay hints.
- Symbol-heavy codebases benefit from `<leader>fs` and `<leader>fS` more than raw grep.

---

## 7. Run tests and tasks

There are two execution systems on purpose.

### Neotest

Use Neotest when your intent is test-focused:

| Key | Action |
| :--- | :--- |
| `<leader>tt` | nearest test |
| `<leader>tf` | current file tests |
| `<leader>ts` | summary |
| `<leader>to` | output |
| `<leader>tp` | output panel |
| `<leader>td` | debug nearest test |

### Overseer

Use Overseer when your intent is task-focused:

| Key | Action |
| :--- | :--- |
| `<leader>or` | run any task/template |
| `<leader>os` | run `package.json` script |
| `<leader>op` | run current Python file |
| `<leader>oT` | run Python tests |
| `<leader>ob` | build current project |
| `<leader>on` | run current project tests |
| `<leader>oC` | compile current C/C++ file |

Rule of thumb:

- use Neotest for single-test and test-file work
- use Overseer for build, run, compile, and project-level commands

---

## 8. Debug in place

Use DAP when the problem is about runtime behavior, not just failing assertions.

Important keys:

| Key | Action |
| :--- | :--- |
| `<leader>db` | breakpoint |
| `<leader>dB` | conditional breakpoint |
| `<leader>dc` | continue |
| `<leader>di` / `<leader>do` / `<leader>dO` | step into / over / out |
| `<leader>dr` | REPL |
| `<leader>du` | DAP UI |
| `<leader>dP` | debug current Python file |
| `<leader>dC` | debug current C/C++ executable |

Current behavior worth knowing:

- Python debugging uses the detected project interpreter when possible.
- C/C++ debugging looks for current-file `.out` binaries and executables in `build/` and `bin/` before prompting manually.
- JS and TS launch through `pwa-node`.

---

## 9. Work with Git continuously

Do not wait until the end of a session to inspect changes.

Useful keys:

| Key | Action |
| :--- | :--- |
| `]h` / `[h` | next / previous hunk |
| `<leader>gp` | preview hunk |
| `<leader>gs` | stage hunk |
| `<leader>gr` | reset hunk |
| `<leader>gS` | stage buffer |
| `<leader>gb` | blame line |
| `<leader>gg` | LazyGit |
| `<leader>go` | Diffview open |
| `<leader>gc` | Diffview close |
| `<leader>gh` | file history |

The fastest working pattern is:

1. Edit.
2. Preview hunks.
3. Stage selectively.
4. Open LazyGit when you need branch-level operations.

---

## 10. A normal daily flow

A compact loop for a real work session:

1. Open the repo with `nvim`.
2. Jump to an entry file with `<leader>fp`.
3. Search the task or bug with `<leader>fg`.
4. Navigate semantically with `gd`, `gr`, and `gi`.
5. Add a few anchor files to Harpoon with `<leader>ha`.
6. Edit and save with `<C-s>`.
7. Run nearest or file tests with `<leader>tt` or `<leader>tf`.
8. Run a project task or build with `<leader>ob`, `<leader>on`, or `<leader>os`.
9. Debug with `<leader>td`, `<leader>dC`, or `<leader>dP` when needed.
10. Review and stage hunks as you go.

That is the intended use of this setup: search-driven, keyboard-first, and execution-oriented.

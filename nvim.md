# Neovim Setup

**Plugin manager**: lazy.nvim
**Leader**: `<Space>` | **Local leader**: `,`
**Theme**: modus-operandi
**Config**: `~/.config/nvim/lua/naamanu/`

---

## Structure

```
init.lua
lua/naamanu/
  core/
    options.lua      — vim settings
    keymaps.lua      — general keybindings
    autocmds.lua     — autocommands
    lazy.lua         — lazy.nvim bootstrap
  exact_plugins/
    colorscheme.lua
    completion.lua
    debug.lua
    editor.lua
    formatting.lua
    git.lua
    lsp.lua
    linting.lua
    navigation.lua
    notebook.lua
    overseer.lua
    pairp.lua
    render-markdown.lua
    snacks.lua
    testing.lua
    treesitter.lua
    ui.lua
```

---

## Plugins

| Category | Plugin(s) |
| :--- | :--- |
| Completion | blink.cmp, friendly-snippets (native vim.snippet engine) |
| LSP | mason, mason-tool-installer, fidget, schemastore, lazydev.nvim |
| Formatting | conform.nvim |
| Linting | nvim-lint |
| Testing | neotest, neotest-python, neotest-vitest, neotest-rust |
| Debugging | nvim-dap, nvim-dap-ui, nvim-dap-virtual-text, mason-nvim-dap, nvim-dap-python |
| Git | gitsigns, lazygit.nvim, diffview.nvim |
| Navigation | oil.nvim, harpoon v2, telescope.nvim |
| Treesitter | nvim-treesitter, nvim-treesitter-textobjects (main), nvim-ts-autotag, nvim-treesitter-context |
| Notebook | molten-nvim, image.nvim |
| Task Runner | overseer.nvim |
| Claude | pairp |
| Markdown | render-markdown.nvim |
| Editor | nvim-autopairs, nvim-surround, Comment.nvim, todo-comments, flash.nvim, undotree, zen-mode, mini.ai, neogen |
| UI | snacks.nvim (notifier, bigfile, quickfile, words, indent, input, scope), lualine, which-key, trouble.nvim, aerial.nvim |
| Theme | modus-themes.nvim |

### LSP servers (auto-installed via mason)

- **C/C++**: clangd
- **Rust**: rust-analyzer
- **Python**: ruff, ty (via eglot preset)
- **Lua**: lua-language-server
- **OCaml**: ocaml-lsp
- **ReasonML**: ocaml-lsp (via `reason` filetype)
- **Haskell**: haskell-language-server
- **Nix**: nil
- **TypeScript/JS**: ts_ls, eslint-lsp
- **Tailwind**: tailwindcss-language-server
- **GraphQL**: graphql-language-service-cli
- **YAML**: yaml-language-server (schemastore)
- **LaTeX**: texlab
- **Docker**: dockerfile-language-server, docker-compose-language-service
- **Ruby**: ruby-lsp
- **Conditional** (if binary on PATH): millet-ls, racket_langserver, coq-lsp, lean4, als, rescript-language-server

### Formatters (conform.nvim)

| Language(s) | Formatter |
| :--- | :--- |
| C, C++ | clang-format |
| Rust | rustfmt |
| OCaml | ocamlformat |
| Python | ruff |
| Haskell | ormolu |
| Nix | nixfmt |
| Lua | stylua |
| Shell/Bash | shfmt |
| JSON, YAML, Markdown, TS, JS, HTML, CSS, GraphQL | prettier |
| Ruby | rubocop |

Format on save enabled with 3s timeout.

---

## Key Options

| Option | Value |
| :--- | :--- |
| Tabs | 2 spaces (expandtab) |
| Line numbers | absolute + relative |
| Color column | 100 |
| Scroll offset | 8 lines |
| Clipboard | system (`unnamedplus`) |
| Folding | treesitter expr, disabled by default |
| Undo | persistent (`~/.vim/undodir`) |
| Swap/backup | disabled |

Language overrides: C/C++/Rust use 4-space tabs.

---

## Autocommands

| Event | Trigger | Action |
| :--- | :--- | :--- |
| TextYankPost | all | Highlight yanked text (200ms) |
| FileType | help, lspinfo, man, qf, query, checkhealth | Map `q` to close |
| BufWritePre | all | Auto-create parent directories |
| FileType | rust, c, cpp | Set tabstop/shiftwidth to 4 |

---

## Keybindings

### General

| Mode | Key | Action |
| :--- | :--- | :--- |
| n | `<Esc>` | Clear search highlights |
| n | `<C-h/j/k/l>` | Window navigation |
| n | `<C-Up/Down>` | Resize window height |
| n | `<C-Left/Right>` | Resize window width |
| n | `<C-d>` / `<C-u>` | Scroll down/up (centered) |
| n | `n` / `N` | Next/prev search result (centered) |
| n | `<C-s>` | Save file |
| n | `<leader>q` | Quit |
| n | `<leader>sv` | Split vertical |
| n | `<leader>sh` | Split horizontal |
| n | `<leader>se` | Equalize splits |
| n | `<leader>sx` | Close split |
| n | `<leader>bn` / `bp` / `bd` | Buffer next/prev/delete |
| v | `<` / `>` | Indent left/right |
| v | `J` / `K` | Move lines down/up |
| x | `<leader>p` | Paste without yanking |

### Completion — blink.cmp

| Key | Action |
| :--- | :--- |
| `<C-j>` / `<Tab>` | Snippet forward / next item |
| `<C-k>` / `<S-Tab>` | Snippet backward / prev item |
| `<CR>` | Accept |
| `<C-Space>` | Open menu |
| `<C-e>` | Cancel |
| `<C-b>` / `<C-f>` | Scroll docs up/down |

**Sources:** lazydev (Neovim Lua API, prioritized), LSP, path, snippets (friendly-snippets), buffer. Snippets use native `vim.snippet`.

### Find — Telescope `<leader>f`

| Key | Action |
| :--- | :--- |
| `<leader>ff` | Find files |
| `<leader>fp` | Git files |
| `<leader>fr` | Recent files |
| `<leader>fg` | Live grep |
| `<leader>f/` | Search current buffer |
| `<leader>f.` | Resume last picker |
| `<leader>fc` | Grep word under cursor |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |
| `<leader>fd` | Diagnostics |
| `<leader>fs` / `fS` | Document / workspace symbols |

### Motion

| Key | Action |
| :--- | :--- |
| `<leader><leader>` | Flash jump |
| `<leader>fj` | Flash Treesitter |
| `<leader>fr` / `fR` | Flash remote / Treesitter search |

### Navigation

| Key | Action |
| :--- | :--- |
| `-` | Oil: open parent directory |
| `<leader>e` | Oil: file explorer |
| `<leader>ha` | Harpoon: add file |
| `<leader>hh` | Harpoon: menu |
| `<leader>1–5` | Harpoon: jump to file 1–5 |
| `<leader>hp` / `hn` | Harpoon: prev/next |

### LSP

| Key | Action |
| :--- | :--- |
| `gd` / `gD` | Definition / declaration |
| `gr` / `gi` / `gt` | References / implementation / type def |
| `K` | Hover docs |
| `<leader>la` | Code action |
| `<leader>lr` | Rename |
| `<leader>ld` | Line diagnostics |
| `<leader>ls` | Signature help |
| `<leader>ci` | Organize imports |
| `<leader>cI` | Add missing imports |
| `<leader>cu` | Remove unused imports |
| `<leader>cF` | Fix all auto-fixable issues |
| `<leader>lh` | Toggle inlay hints |
| `<leader>lc` | Run code lens |
| `<leader>lC` | Refresh code lens |

**Inlay hints** auto-enabled for supporting servers (rust-analyzer, ts_ls, lua_ls). Toggle per-buffer with `<leader>lh`. **Code lens** auto-refreshes on `BufEnter`/`InsertLeave`. **Lazydev** provides full Neovim Lua API completions in `*.lua` files.

### Formatting & Linting

| Mode | Key | Action |
| :--- | :--- | :--- |
| n, v | `<leader>cf` | Format buffer/selection |
| n | `<leader>ll` | Trigger lint |

### Code Outline — aerial `<leader>co`

| Key | Action |
| :--- | :--- |
| `<leader>co` | Toggle code outline sidebar |
| `[s` / `]s` | Previous / next symbol |

### Trouble `<leader>x`

| Key | Action |
| :--- | :--- |
| `<leader>xx` | Workspace diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xQ` | Quickfix list |
| `<leader>cs` | Symbols |
| `<leader>cl` | LSP references/definitions |

### Git — gitsigns `<leader>g`

| Mode | Key | Action |
| :--- | :--- | :--- |
| n | `]h` / `[h` | Next/prev hunk |
| n, v | `<leader>gs` / `gr` | Stage/reset hunk |
| n | `<leader>gS` / `gR` | Stage/reset buffer |
| n | `<leader>gu` | Undo stage |
| n | `<leader>gp` / `gb` | Preview hunk / blame line |
| n | `<leader>gd` / `gD` | Diff this / diff this ~ |
| n | `<leader>gg` | LazyGit |
| n | `<leader>go` / `gc` / `gh` | Diffview open/close/history |

### Testing — neotest `<leader>t`

| Key | Action |
| :--- | :--- |
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run file tests |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Test output |
| `<leader>tp` | Toggle output panel |
| `<leader>tS` | Stop test |
| `<leader>td` | Debug nearest test |
| `[t` / `]t` | Previous / next failed test |

**Adapters:** Python, Vitest (JS/TS), Rust.

### Debugging — nvim-dap `<leader>d`

| Key | Action |
| :--- | :--- |
| `<leader>db` / `dB` | Breakpoint / conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` / `do` / `dO` | Step into/over/out |
| `<leader>dr` / `dl` | Toggle REPL / run last |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Eval expression |

**Adapters:** js-debug-adapter (JS/TS), codelldb (C/C++/Rust), nvim-dap-python (Python). DAP UI auto-opens/closes.

### Claude — Pairp `<leader>c`

| Key | Action |
| :--- | :--- |
| `<leader>cc` | Toggle Claude Code window |

### Notebook — molten-nvim `<leader>m`

| Key | Action |
| :--- | :--- |
| `<leader>mi` | Initialize Molten kernel |
| `<leader>me` | Evaluate operator |
| `<leader>ml` | Evaluate line |
| `<leader>mr` | Re-evaluate cell |
| `<leader>md` | Delete cell |
| `<leader>mo` | Show output |

Requires a Jupyter kernel registered for the project. Use the `jk` fish function to register the current uv venv.

### Task Runner — overseer `<leader>o`

| Key | Action |
| :--- | :--- |
| `<leader>or` | Run task |
| `<leader>ot` | Toggle task panel |
| `<leader>oa` | Task action |

### Snacks — notifications & utilities

| Key | Action |
| :--- | :--- |
| `<leader>n` | Notification history |
| `<leader>nd` | Dismiss notifications |
| `<leader>rf` | Rename file |
| `]]` / `[[` | Next/prev reference (word under cursor) |

**Auto-enabled features:** bigfile detection, quickfile, indent guides, scope highlighting, input UI.

### Treesitter

| Mode | Key | Action |
| :--- | :--- | :--- |
| n | `<C-space>` | Init / grow selection |
| n | `<BS>` | Shrink selection |
| x, o | `af` / `if` | Around/inside function |
| x, o | `ac` / `ic` | Around/inside class |
| n, x, o | `]f` / `]c` | Next function/class start |
| n, x, o | `[f` / `[c` | Prev function/class start |

### Editor

| Mode | Key | Plugin | Action |
| :--- | :--- | :--- | :--- |
| n, x, o | `s` / `S` | flash.nvim | Jump / treesitter jump |
| o | `r` | flash.nvim | Remote flash |
| o, x | `R` | flash.nvim | Treesitter search |
| n | `<leader>u` | undotree | Toggle undotree |
| n | `<leader>z` | zen-mode | Toggle zen mode |
| n | `<leader>cn` | neogen | Generate documentation |
| n | `gcc` | Comment.nvim | Toggle line comment |
| v | `gc` / `gb` | Comment.nvim | Line/block comment |

### Mini.ai text objects

| Mode | Key | Object |
| :--- | :--- | :--- |
| o, v | `af` / `if` | Around/inside function |
| o, v | `ac` / `ic` | Around/inside class |
| o, v | `ab` / `ib` | Around/inside block |
| o, v | `ad` / `id` | Around/inside digits |
| o, v | `ae` / `ie` | Around/inside function call |

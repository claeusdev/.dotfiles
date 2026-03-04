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
    treesitter.lua
    ui.lua
```

---

## Plugins

| Category | Plugin(s) |
| :--- | :--- |
| Completion | blink.cmp, friendly-snippets |
| LSP | mason, mason-tool-installer, fidget, schemastore |
| Formatting | conform.nvim |
| Linting | nvim-lint |
| Debugging | nvim-dap, nvim-dap-ui, nvim-dap-virtual-text, mason-nvim-dap, nvim-dap-python |
| Git | gitsigns, lazygit.nvim, diffview.nvim |
| Navigation | oil.nvim, harpoon v2, telescope.nvim |
| Treesitter | nvim-treesitter, nvim-treesitter-textobjects (main), nvim-ts-autotag, nvim-treesitter-context |
| Editor | nvim-autopairs, nvim-surround, Comment.nvim, todo-comments, flash.nvim, undotree, zen-mode, mini.ai |
| UI | lualine, which-key, trouble.nvim |
| Theme | modus-themes.nvim |

### LSP servers (auto-installed via mason)

- **C/C++**: clangd
- **Rust**: rust-analyzer
- **Python**: ruff, ty (via eglot preset)
- **Lua**: lua-language-server
- **OCaml**: ocaml-lsp
- **Haskell**: haskell-language-server
- **Nix**: nil
- **TypeScript/JS**: ts_ls, eslint-lsp
- **Tailwind**: tailwindcss-language-server
- **GraphQL**: graphql-language-service-cli
- **YAML**: yaml-language-server (schemastore)
- **Docker**: dockerfile-language-server, docker-compose-language-service
- **Ruby**: ruby-lsp
- **Conditional** (if binary on PATH): millet-ls, racket_langserver, coq-lsp, lean4, als

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
| `<C-j>` / `<Tab>` | Next item |
| `<C-k>` / `<S-Tab>` | Previous item |
| `<CR>` | Accept |
| `<C-Space>` | Open menu |
| `<C-e>` | Cancel |
| `<C-b>` / `<C-f>` | Scroll docs up/down |

### Find — Telescope `<leader>f`

| Key | Action |
| :--- | :--- |
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fg` | Live grep |
| `<leader>fc` | Grep word under cursor |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |
| `<leader>fd` | Diagnostics |
| `<leader>fs` / `fS` | Document / workspace symbols |

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

### Formatting & Linting

| Mode | Key | Action |
| :--- | :--- | :--- |
| n, v | `<leader>cf` | Format buffer/selection |
| n | `<leader>ll` | Trigger lint |

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

### Debugging — nvim-dap `<leader>d`

| Key | Action |
| :--- | :--- |
| `<leader>db` / `dB` | Breakpoint / conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` / `do` / `dO` | Step into/over/out |
| `<leader>dr` / `dl` | Toggle REPL / run last |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Eval expression |

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

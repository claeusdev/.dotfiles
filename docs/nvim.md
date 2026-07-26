# Neovim Setup

**Plugin manager**: lazy.nvim
**Leader**: `<Space>` | **Local leader**: `,`
**Theme**: Modus Vivendi
**Config**: `~/.config/nvim/lua/naamanu/`

Tutorial guides:

- [Neovim Tutorials](nvim-tutorials.md)
- [Neovim Development Workflow](nvim-dev-workflow.md)
- [Neovim Note-Taking Workflow](nvim-note-taking-workflow.md)
- [Neovim Starting Projects](nvim-starting-projects.md)

---

## Structure

```text
init.lua
lua/naamanu/
  core/
    options.lua
    keymaps.lua
    autocmds.lua
    lazy.lua
    tasks.lua
  exact_plugins/
    colorscheme.lua
    completion.lua
    editor.lua
    formatting.lua
    git.lua
    http.lua
    linting.lua
    lsp.lua
    navigation.lua
    overseer.lua
    render-markdown.lua
    snacks.lua
    treesitter.lua
    ui.lua
```

---

## Plugin Inventory

| Category | Plugin(s) |
| :--- | :--- |
| Completion | blink.cmp, friendly-snippets, native `vim.snippet` |
| LSP | native `vim.lsp`, mason, mason-tool-installer, fidget, schemastore, lazydev.nvim, inc-rename |
| Formatting | conform.nvim |
| Linting | nvim-lint |
| Git | gitsigns, diffview.nvim, snacks.lazygit |
| Navigation | oil.nvim, snacks.picker (also backs `vim.ui.select`) |
| Treesitter | nvim-treesitter (main branch), nvim-treesitter-textobjects, nvim-ts-autotag, nvim-treesitter-context |
| Task runner | overseer.nvim |
| HTTP | kulala.nvim |
| Markdown | render-markdown.nvim |
| Editor | nvim-autopairs, nvim-surround, builtin `gc` comments, todo-comments, flash.nvim, undotree, treesj, snacks.zen |
| AI | cc-nvim (`<leader>a` group) |
| UI | snacks.nvim, lualine, which-key, trouble.nvim |
| Theme | modus-themes.nvim |

Native LSP configuration (vim.lsp.config/enable) lives in `lua/naamanu/core/lsp.lua`, required from `core/init.lua` after lazy.nvim. The nvim-treesitter `main` branch needs the `tree-sitter` CLI on PATH to compile parsers (`brew install tree-sitter-cli`).

---

## Language Support

### LSP servers

| Language | Server |
| :--- | :--- |
| C/C++ | clangd |
| Rust | rust-analyzer |
| Python | ruff, basedpyright |
| Lua | lua-language-server |
| OCaml / Reason | ocaml-lsp |
| Haskell | haskell-language-server |
| TypeScript / JavaScript / React | vtsls, eslint-lsp |
| Vue / CSS / Tailwind | vtsls, css-lsp, tailwindcss-language-server |
| JSON / YAML | json-lsp, yaml-language-server |

Ruff handles Python lint/fix actions. basedpyright owns Python hover and type intelligence (matching the Emacs setup); Ruff hover is disabled to avoid duplicate hover providers.

### Formatters

| Language(s) | Formatter |
| :--- | :--- |
| C, C++ | clang-format |
| Rust | rustfmt |
| Python | ruff fix + ruff format |
| OCaml | ocamlformat |
| Haskell | ormolu |
| Lua | stylua |
| Shell/Bash | shfmt |
| SQL | sql-formatter |
| JS, TS, JSX, TSX, Vue, JSON, YAML, Markdown, HTML, CSS, SCSS | prettier |

Format on save is enabled with a 3s timeout. JS/TS/Vue formatting uses Prettier directly and does not fall back to LSP formatting.

---

## Core Keybindings

### General

| Key | Action |
| :--- | :--- |
| `<Esc>` | Clear search highlights |
| `<C-h/j/k/l>` | Window navigation |
| `<C-Up/Down>` | Resize window height |
| `<C-Left/Right>` | Resize window width |
| `<C-s>` | Save file |
| `<leader>q` | Quit |
| `<leader>sv` / `<leader>sh` | Vertical / horizontal split |
| `<leader>bn` / `<leader>bp` / `<leader>bd` | Buffer next / previous / delete |

### Find and Navigation

| Key | Action |
| :--- | :--- |
| `-` | Open Oil parent directory |
| `<leader>e` | Open Oil file explorer |
| `<leader>ff` | Find files |
| `<leader>fp` | Project files, using Git files when possible |
| `<leader>fr` | Recent files |
| `<leader>fg` | Live grep |
| `<leader>f/` | Search current buffer |
| `<leader>f.` | Resume last picker |
| `<leader>fc` | Grep word under cursor |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |
| `<leader>fd` | Diagnostics |
| `<leader>fs` / `<leader>fS` | Document / workspace symbols |
| `<leader><leader>` | Flash jump |

### LSP

| Key | Action |
| :--- | :--- |
| `gd` / `gD` | Definition / declaration |
| `gr` / `gi` / `gt` | References / implementation / type definition |
| `K` | Hover docs |
| `<leader>la` | Code action |
| `<leader>lr` | Rename with live preview |
| `<leader>ld` | Line diagnostics |
| `<leader>ls` | Signature help |
| `<leader>ci` | Organize imports |
| `<leader>cI` | Add missing imports |
| `<leader>cu` | Remove unused imports |
| `<leader>cF` | Fix all auto-fixable issues |
| `<leader>cE` | Fix ESLint issues |
| `<leader>lh` | Toggle inlay hints |
| `<leader>lc` | Run code lens |
| `<leader>lC` | Enable code lens |
| `<leader>lR` | Restart attached LSP clients |

### Formatting and Linting

| Key | Action |
| :--- | :--- |
| `<leader>cf` | Format buffer or visual selection |
| `<leader>ll` | Trigger linting |

### Tasks - Overseer

| Key | Action |
| :--- | :--- |
| `<leader>or` | Run any Overseer task/template |
| `<leader>os` | Pick and run a `package.json` script |
| `<leader>od` | Run `dev` package script |
| `<leader>ol` | Run `lint` package script |
| `<leader>oy` | Run `typecheck` package script |
| `<leader>of` | Run `format` package script |
| `<leader>op` | Run current Python file |
| `<leader>oT` | Run Python tests with pytest |
| `<leader>ob` | Build current project |
| `<leader>on` | Run current project tests |
| `<leader>oC` | Compile current C/C++ file |
| `<leader>ot` | Toggle task panel |
| `<leader>oa` | Task action |

Project-aware tasks support Node package scripts, Python (`uv run python`, pytest), C/C++ (`cmake`, `meson`, `make`), Rust (`cargo`), OCaml (`dune`), and Haskell (`cabal`, `stack`).

### Git

| Key | Action |
| :--- | :--- |
| `]h` / `[h` | Next / previous hunk |
| `<leader>gs` / `<leader>gr` | Stage / reset hunk |
| `<leader>gS` / `<leader>gR` | Stage / reset buffer |
| `<leader>gu` | Undo stage hunk |
| `<leader>gp` / `<leader>gb` | Preview hunk / blame line |
| `<leader>gd` / `<leader>gD` | Diff this / diff against previous |
| `<leader>gg` | LazyGit |
| `<leader>go` / `<leader>gc` / `<leader>gh` | Diffview open / close / file history |

### Trouble

| Key | Action |
| :--- | :--- |
| `<leader>xx` | Workspace diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xQ` | Quickfix list |
| `<leader>cs` | Symbols |
| `<leader>cl` | LSP references/definitions |

### Treesitter

| Mode | Key | Action |
| :--- | :--- | :--- |
| n | `<C-space>` | Init / grow selection |
| n | `<BS>` | Shrink selection |
| x, o | `af` / `if` | Around / inside function |
| x, o | `ac` / `ic` | Around / inside class |
| n, x, o | `]f` / `[f` | Next / previous function |
| n, x, o | `]c` / `[c` | Next / previous class |

### Editor Utilities

| Key | Action |
| :--- | :--- |
| `gcc`, visual `gc` / `gb` | Comment line / selection |
| `<leader>u` | Toggle undotree |
| `<leader>z` | Toggle zen mode |
| `<leader>j` | Split / join node with treesj |
| `<leader>n` / `<leader>nd` | Notification history / dismiss notifications |
| `<leader>rf` | Rename current file |
| `]]` / `[[` | Next / previous reference for word under cursor |

---

## Validation

Useful checks after config edits:

```sh
nvim --headless +qa
nvim --headless '+checkhealth vim.deprecated' '+qa'
stylua dot_config/nvim/lua/naamanu
```

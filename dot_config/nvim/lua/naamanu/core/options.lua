local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.colorcolumn = "100"
opt.fillchars:append({ eob = " " })

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Swap and backup
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.vim/undodir")

-- Mouse
opt.mouse = "a"

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = "menu,menuone,noinsert"

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Folding (using treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable = false

-- Show invisible characters
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- File encoding
opt.fileencoding = "utf-8"

-- Add mise shims to PATH so nvim can find mise-managed tools (ruby, etc.)
local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
if vim.fn.isdirectory(mise_shims) == 1 then
  vim.env.PATH = mise_shims .. ":" .. vim.env.PATH
end

-- Disable unused providers
vim.g.loaded_perl_provider = 0

-- Python provider: dedicated uv venv (created by setup.sh)
local python_venv = vim.fn.expand("~/.local/share/nvim/venv/bin/python")
if vim.fn.filereadable(python_venv) == 1 then
  vim.g.python3_host_prog = python_venv
end

-- Ruby provider: unused, disable to avoid warnings
vim.g.loaded_ruby_provider = 0


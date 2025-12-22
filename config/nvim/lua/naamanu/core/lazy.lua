-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Import plugins from lua/naamanu/plugins
  spec = {
    { import = "naamanu.plugins" },
    { import = "naamanu.plugins.lsp" },
  },
  -- Configure lazy.nvim
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = "rounded",
  },
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

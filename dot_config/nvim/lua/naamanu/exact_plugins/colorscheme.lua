return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  opts = {
    flavour = "mocha",
    dim_inactive = { enabled = false },
    styles = {
      comments = { "italic" },
      keywords = { "italic" },
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      treesitter = true,
      mason = true,
      telescope = { enabled = true },
      native_lsp = { enabled = true },
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}

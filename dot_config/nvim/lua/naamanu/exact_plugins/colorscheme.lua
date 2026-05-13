return {
  "miikanissi/modus-themes.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    style = "modus_vivendi",
    variants = {
      modus_vivendi = "default",
    },
    dim_inactive = false,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
    },
  },
  config = function(_, opts)
    require("modus-themes").setup(opts)
    vim.cmd.colorscheme("modus_vivendi")
  end,
}

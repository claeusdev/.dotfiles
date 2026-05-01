return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>Op", "<cmd>Octo pr list<CR>", desc = "PR list" },
    { "<leader>OP", "<cmd>Octo pr create<CR>", desc = "PR create" },
    { "<leader>Oi", "<cmd>Octo issue list<CR>", desc = "Issue list" },
    { "<leader>OI", "<cmd>Octo issue create<CR>", desc = "Issue create" },
    { "<leader>Or", "<cmd>Octo review start<CR>", desc = "Start review" },
    { "<leader>Os", "<cmd>Octo search<CR>", desc = "Search GitHub" },
  },
  opts = {
    suppress_missing_scope = { projects_v2 = true },
    picker = "telescope",
  },
}

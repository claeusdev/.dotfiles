return {
  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "harpoon" },
        { "<leader>l", group = "lsp" },
        { "<leader>m", group = "molten" },
        { "<leader>n", group = "notify" },
        { "<leader>o", group = "overseer" },
        { "<leader>O", group = "Octo (GitHub)" },
        { "<leader>P", group = "Package.json" },
        { "<leader>r", group = "rename" },
        { "<leader>R", group = "REST/HTTP" },
        { "<leader>s", group = "split" },
        { "<leader>t", group = "test" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>x", group = "trouble" },
      },
    },
  },

  -- Aerial (code outline)
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>co", "<cmd>AerialToggle!<CR>", desc = "Code outline (Aerial)" },
      { "[s", "<cmd>AerialPrev<CR>", desc = "Previous symbol" },
      { "]s", "<cmd>AerialNext<CR>", desc = "Next symbol" },
    },
    opts = {
      backends = { "treesitter", "lsp" },
      layout = {
        min_width = 30,
        default_direction = "prefer_right",
      },
      show_guides = true,
      filter_kind = false,
    },
  },

  -- Trouble
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP refs/defs (Trouble)" },
    },
    opts = {},
  },
}

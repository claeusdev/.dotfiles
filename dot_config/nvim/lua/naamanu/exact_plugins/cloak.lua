return {
  "laytan/cloak.nvim",
  event = { "BufReadPre .env*", "BufNewFile .env*" },
  keys = {
    { "<leader>uc", "<cmd>CloakToggle<CR>", desc = "Toggle .env masking" },
  },
  opts = {
    enabled = true,
    cloak_character = "*",
    highlight_group = "Comment",
    cloak_length = 8,
    try_all_patterns = true,
    patterns = {
      {
        file_pattern = { ".env*", "wrangler.toml", ".dev.vars" },
        cloak_pattern = "=.+",
      },
    },
  },
}

return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  keys = {
    { "<leader>rs", function() require("kulala").run() end, desc = "HTTP send request" },
    { "<leader>ra", function() require("kulala").run_all() end, desc = "HTTP send all" },
    { "<leader>rt", function() require("kulala").toggle_view() end, desc = "HTTP toggle view" },
    { "<leader>rl", function() require("kulala").replay() end, desc = "HTTP replay last" },
    { "<leader>rc", function() require("kulala").copy() end, desc = "HTTP copy as curl" },
    { "<leader>ri", function() require("kulala").inspect() end, desc = "HTTP inspect request" },
    { "<leader>r]", function() require("kulala").jump_next() end, desc = "HTTP next request" },
    { "<leader>r[", function() require("kulala").jump_prev() end, desc = "HTTP prev request" },
    { "<leader>re", function() require("kulala").set_selected_env() end, desc = "HTTP select env" },
  },
  opts = {
    default_view = "body",
    default_env = "dev",
    debug = false,
  },
}

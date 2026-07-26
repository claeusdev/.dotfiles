return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    quickfile = { enabled = true },
    words = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    scope = { enabled = true },
    dashboard = { enabled = true },
    scratch = { enabled = true },
  },
  keys = {
    -- <leader>nh (not <leader>n): the bare key is the notify group prefix.
    { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification history" },
    { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
    { "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },
    { "<leader>rf", function() Snacks.rename.rename_file() end, desc = "Rename file" },
    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle scratch buffer" },
    { "<leader>S", function() Snacks.scratch.select() end, desc = "Select scratch buffer" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },
  },
}

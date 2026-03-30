return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerRun",
    "OverseerToggle",
    "OverseerOpen",
  },
  keys = {
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run task" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle panel" },
    { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Overseer: Task action" },
  },
  opts = {
    strategy = "terminal",
    task_list = {
      direction = "bottom",
      min_height = 15,
      default_detail = 1,
    },
  },
}

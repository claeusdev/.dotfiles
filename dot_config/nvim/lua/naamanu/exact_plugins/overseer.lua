return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerRun",
    "OverseerToggle",
    "OverseerOpen",
  },
  keys = {
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run task" },
    { "<leader>os", function() require("naamanu.core.tasks").run_package_script() end, desc = "Overseer: Run package script" },
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

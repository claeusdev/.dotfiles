return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest",
    "nvim-neotest/neotest-python",
    "marilari88/neotest-vitest",
    "rouge8/neotest-rust",
  },
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
    { "<leader>to", function() require("neotest").output.open({ enter_on_open = true }) end, desc = "Test output" },
    { "<leader>tp", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop test" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
    { "[t", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Previous failed test" },
    { "]t", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next failed test" },
  },
  config = function()
    local tasks = require("naamanu.core.tasks")
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = function()
            return tasks.detect_python_test_runner(vim.fn.expand("%:p"))
          end,
          python = function(root)
            return tasks.python_runner_command(root)
          end,
        }),
        require("neotest-jest")({
          jestCommand = function()
            local cmd = tasks.package_script_command("test", vim.fn.expand("%:p"))
            return cmd and table.concat(cmd, " ") .. " --" or "npm test --"
          end,
          env = { CI = true },
          cwd = function()
            return tasks.find_package_root(vim.fn.expand("%:p")) or vim.fn.getcwd()
          end,
        }),
        require("neotest-vitest"),
        require("neotest-rust"),
      },
    })
  end,
}

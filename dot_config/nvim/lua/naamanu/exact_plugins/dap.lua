return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" }, opts = {} },
  },
  keys = {
    { "<leader>dd", function() require("dap").continue() end, desc = "Debug start/continue" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug breakpoint" },
    { "<leader>dn", function() require("dap").step_over() end, desc = "Debug step over" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Debug step into" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Debug step out" },
    { "<leader>dq", function() require("dap").terminate() end, desc = "Debug terminate" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Debug UI" },
  },
  config = function()
    local dap = require("dap")
    dap.listeners.before.attach.dotfiles = function() require("dapui").open() end
    dap.listeners.before.launch.dotfiles = function() require("dapui").open() end
    dap.listeners.before.event_terminated.dotfiles = function() require("dapui").close() end
    dap.listeners.before.event_exited.dotfiles = function() require("dapui").close() end

    if vim.fn.executable("python") == 1 then
      dap.adapters.python = { type = "executable", command = "python", args = { "-m", "debugpy.adapter" } }
      dap.configurations.python = {{ type = "python", request = "launch", name = "Current file", program = "${file}", cwd = "${workspaceFolder}" }}
    end
    if vim.fn.executable("lldb-dap") == 1 then
      dap.adapters.lldb = { type = "executable", command = "lldb-dap", name = "lldb" }
      local native = {{ type = "lldb", request = "launch", name = "Launch executable", program = function() return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file") end, cwd = "${workspaceFolder}", stopOnEntry = false }}
      dap.configurations.c = native
      dap.configurations.cpp = native
      dap.configurations.rust = native
    end
    if vim.fn.executable("dlv") == 1 then
      dap.adapters.go = function(callback)
        local port = 38697
        vim.fn.jobstart({ "dlv", "dap", "-l", "127.0.0.1:" .. port }, { detach = true })
        vim.defer_fn(function() callback({ type = "server", host = "127.0.0.1", port = port }) end, 100)
      end
      dap.configurations.go = {{ type = "go", name = "Debug package", request = "launch", program = "${fileDirname}" }}
    end
  end,
}

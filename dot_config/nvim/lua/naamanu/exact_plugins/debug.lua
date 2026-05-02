return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "jay-babu/mason-nvim-dap.nvim",
    "mfussenegger/nvim-dap-python",
  },
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    { "<leader>dC", function()
      local tasks = require("naamanu.core.tasks")
      require("dap").run({
        type = "codelldb",
        request = "launch",
        name = "Launch C/C++ executable",
        program = tasks.c_family_debug_program(vim.api.nvim_buf_get_name(0)),
        cwd = tasks.find_cpp_root(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd(),
        args = tasks.prompt_program_args(),
      })
    end, desc = "Debug C/C++ executable" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local tasks = require("naamanu.core.tasks")

    -- Mason DAP
    require("mason-nvim-dap").setup({
      ensure_installed = { "codelldb", "js-debug-adapter" },
      automatic_installation = true,
    })

    -- Node.js / js-debug-adapter
    local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = { js_debug_path, "${port}" },
      },
    }

    for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
      dap.configurations[ft] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch TypeScript file via tsx",
          runtimeExecutable = function()
            local tsx = tasks.local_package_binary("tsx", vim.api.nvim_buf_get_name(0))
            return tsx or "tsx"
          end,
          args = { "${file}" },
          cwd = function()
            return tasks.find_package_root(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()
          end,
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to process (port 9229)",
          processId = require("dap.utils").pick_process,
          port = 9229,
          cwd = "${workspaceFolder}",
        },
      }
    end

    -- DAP UI
    dapui.setup()

    -- Virtual text
    require("nvim-dap-virtual-text").setup()

    -- C/C++/Rust via codelldb
    local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
    if vim.fn.executable(codelldb_path) == 1 then
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }

      for _, ft in ipairs({ "c", "cpp" }) do
        dap.configurations[ft] = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch C/C++ executable",
            program = function()
              return tasks.c_family_debug_program(vim.api.nvim_buf_get_name(0))
            end,
            cwd = function()
              return tasks.find_cpp_root(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()
            end,
            args = function()
              return tasks.prompt_program_args()
            end,
          },
          {
            type = "codelldb",
            request = "attach",
            name = "Attach to process",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      dap.configurations.rust = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch executable",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to process",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end

    -- Python DAP
    local ok, dap_python = pcall(require, "dap-python")
    if ok then
      local debugpy = vim.fn.exepath("uv") ~= "" and "uv" or tasks.python_executable(vim.fn.getcwd())
      dap_python.setup(debugpy)
      dap_python.resolve_python = function()
        return tasks.python_executable(vim.api.nvim_buf_get_name(0))
      end
      dap_python.test_runner = function()
        return tasks.detect_python_test_runner(vim.api.nvim_buf_get_name(0))
      end

      dap.configurations.python = dap.configurations.python or {}
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch current Python file",
        program = "${file}",
        cwd = function()
          return tasks.find_python_root(vim.api.nvim_buf_get_name(0)) or vim.fn.getcwd()
        end,
        pythonPath = function()
          return tasks.python_executable(vim.api.nvim_buf_get_name(0))
        end,
      })
    end

    -- Auto open/close DAP UI
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
  end,
  init = function()
    vim.keymap.set("n", "<leader>dP", function()
      local tasks = require("naamanu.core.tasks")
      local filepath = vim.api.nvim_buf_get_name(0)
      require("dap").run({
        type = "python",
        request = "launch",
        name = "Launch current Python file",
        program = filepath,
        cwd = tasks.find_python_root(filepath) or vim.fn.getcwd(),
        pythonPath = tasks.python_executable(filepath),
      })
    end, { desc = "Debug Python file" })
  end,
}

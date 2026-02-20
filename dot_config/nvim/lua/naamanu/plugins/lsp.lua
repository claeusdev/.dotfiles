return {
  -- Mason (tool installer)
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = { border = "rounded" },
    },
  },

  -- Mason tool installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        -- LSP servers
        "clangd",
        "rust-analyzer",
        "lua-language-server",
        "ruff",
        "ty",
        "ocaml-lsp",
        "haskell-language-server",
        "nil",
        -- Formatters
        "clang-format",
        "stylua",
        "shfmt",
        "prettier",
        "nixfmt",
        "ormolu",
        -- Linters
        "shellcheck",
        -- DAP
        "codelldb",
      },
    },
  },

  -- Fidget (LSP progress)
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- Native LSP configuration (no plugin needed, uses vim.lsp.config/enable)
  {
    dir = ".",
    name = "native-lsp",
    lazy = false,
    priority = 900,
    config = function()
      local lsp = vim.lsp

      -- Diagnostic config
      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded" },
      })

      -- Mason-installable servers
      lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy" },
      })

      lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
            cargo = { allFeatures = true },
          },
        },
      })

      lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      lsp.config("ruff", {})

      lsp.config("ty", {})

      lsp.config("ocamllsp", {})

      lsp.config("hls", {
        settings = {
          haskell = {
            formattingProvider = "ormolu",
          },
        },
      })

      lsp.config("nil_ls", {
        settings = {
          ["nil"] = {
            formatting = { command = { "nixfmt" } },
          },
        },
      })

      -- Enable Mason-installable servers
      lsp.enable({
        "clangd",
        "rust_analyzer",
        "lua_ls",
        "ruff",
        "ty",
        "ocamllsp",
        "hls",
        "nil_ls",
      })

      -- Non-Mason servers (conditionally enabled if binary exists)
      local conditional_servers = {
        { name = "millet", cmd = "millet-ls" },
        { name = "racket_langserver", cmd = "racket", config = { cmd = { "racket", "--lib", "racket-langserver" } } },
        { name = "coq_lsp", cmd = "coq-lsp" },
        { name = "lean4", cmd = "lean" },
        { name = "als", cmd = "als" },
      }

      for _, server in ipairs(conditional_servers) do
        if vim.fn.executable(server.cmd) == 1 then
          if server.config then
            lsp.config(server.name, server.config)
          else
            lsp.config(server.name, {})
          end
          lsp.enable(server.name)
        end
      end

      -- LspAttach keybindings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("gi", vim.lsp.buf.implementation, "Go to implementation")
          map("gt", vim.lsp.buf.type_definition, "Go to type definition")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>la", vim.lsp.buf.code_action, "Code action")
          map("<leader>lr", vim.lsp.buf.rename, "Rename")
          map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
          map("<leader>ls", vim.lsp.buf.signature_help, "Signature help")

          -- Disable hover for ruff (defer to ty)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })
    end,
  },
}

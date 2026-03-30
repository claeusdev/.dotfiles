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
        "typescript-language-server",
        "eslint-lsp",
        "tailwindcss-language-server",
        "graphql-language-service-cli",
        "yaml-language-server",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "ruby-lsp",
        "rubocop",
        -- Formatters
        "stylua",
        "shfmt",
        "prettier",
        "nixfmt",
        "ormolu",
        -- Linters
        "shellcheck",
        -- DAP
        "codelldb",
        -- LaTeX
        "texlab",
      },
    },
  },

  -- Fidget (LSP progress)
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- Lazydev (Lua/Neovim API completions)
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- Native LSP configuration (no plugin needed, uses vim.lsp.config/enable)
  {
    dir = ".",
    name = "native-lsp",
    lazy = false,
    priority = 900,
    dependencies = {
      "b0o/schemastore.nvim",
    },
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
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      })

      lsp.config("rust_analyzer", {
        filetypes = { "rust" },
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
            cargo = { allFeatures = true },
            inlayHints = {
              bindingModeHints = { enable = true },
              closureReturnTypeHints = { enable = "always" },
              lifetimeElisionHints = { enable = "always" },
            },
          },
        },
      })

      lsp.config("lua_ls", {
        filetypes = { "lua" },
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
      })

      lsp.config("ruff", {
        filetypes = { "python" },
      })

      lsp.config("ty", {
        filetypes = { "python" },
      })

      lsp.config("ocamllsp", {
        filetypes = { "ocaml", "ocaml.interface", "ocaml.menhir", "ocaml.cram", "ocaml.ocamllex", "ocaml.ocamlyacc" },
      })

      lsp.config("hls", {
        filetypes = { "haskell", "lhaskell", "cabal" },
        settings = {
          haskell = {
            formattingProvider = "ormolu",
          },
        },
      })

      lsp.config("nil_ls", {
        filetypes = { "nix" },
        settings = {
          ["nil"] = {
            formatting = { command = { "nixfmt" } },
          },
        },
      })

      lsp.config("ts_ls", {
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        init_options = {
          preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        single_file_support = true,
      })

      lsp.config("eslint", {
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro", "graphql" },
        settings = {
          codeActionOnSave = {
            enable = true,
            mode = "all",
          },
        },
      })

      lsp.config("tailwindcss", {
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
      })

      lsp.config("graphql", {
        filetypes = { "graphql", "typescriptreact", "javascriptreact" },
      })

      lsp.config("yamlls", {
        filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
            validate = { enable = true },
          },
        },
      })

      lsp.config("dockerls", {
        filetypes = { "dockerfile" },
      })

      lsp.config("docker_compose_language_service", {
        filetypes = { "yaml.docker-compose" },
      })

      lsp.config("ruby_lsp", {
        filetypes = { "ruby", "eruby" },
      })

      lsp.config("texlab", {
        filetypes = { "tex", "plaintex", "bib" },
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
        "ts_ls",
        "eslint",
        "tailwindcss",
        "graphql",
        "yamlls",
        "dockerls",
        "docker_compose_language_service",
        "ruby_lsp",
        "texlab",
      })

      -- Non-Mason servers (conditionally enabled if binary exists)
      local conditional_servers = {
        { name = "millet", cmd = "millet-ls", config = { filetypes = { "sml", "mlb" } } },
        { name = "racket_langserver", cmd = "racket", config = { cmd = { "racket", "--lib", "racket-langserver" }, filetypes = { "racket", "scheme" } } },
        { name = "coq_lsp", cmd = "coq-lsp", config = { filetypes = { "coq" } } },
        { name = "lean4", cmd = "lean", config = { filetypes = { "lean" } } },
        { name = "als", cmd = "als", config = { filetypes = { "ada" } } },
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

          -- Inlay hints (Neovim 0.10+)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            map("<leader>lh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
            end, "Toggle inlay hints")
          end

          -- Code lens
          if client and client.supports_method("textDocument/codeLens") then
            map("<leader>lc", vim.lsp.codelens.run, "Run code lens")
            map("<leader>lC", vim.lsp.codelens.refresh, "Refresh code lens")
            vim.lsp.codelens.refresh({ bufnr = event.buf })
            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
              buffer = event.buf,
              callback = function()
                vim.lsp.codelens.refresh({ bufnr = event.buf })
              end,
            })
          end

          -- Disable hover for ruff (defer to ty)
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })
    end,
  },
}

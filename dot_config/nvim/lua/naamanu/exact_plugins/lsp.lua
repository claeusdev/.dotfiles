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
        "vtsls",
        "biome",
        "eslint-lsp",
        "tailwindcss-language-server",
        "graphql-language-service-cli",
        "json-lsp",
        "yaml-language-server",
        "dockerfile-language-server",
        "docker-compose-language-service",
        -- Formatters
        "stylua",
        "shfmt",
        "prettier",
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

  -- Live-preview LSP rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
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
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      local function mason_binary(binary)
        local candidate = mason_bin .. "/" .. binary
        return vim.fn.executable(candidate) == 1 and candidate or nil
      end
      local function available_binary(binary)
        return mason_binary(binary) or (vim.fn.exepath(binary) ~= "" and vim.fn.exepath(binary) or nil)
      end
      local function mason_cmd(binary, extra_args)
        local executable = available_binary(binary)
        if not executable then
          return nil
        end

        return vim.list_extend({ executable }, extra_args or {})
      end
      local function apply_code_action(kind)
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            only = { kind },
            diagnostics = {},
          },
        })
      end
      local function local_package_binary(root, binary)
        if not root then
          return nil
        end

        local dir = root
        local home = vim.loop.os_homedir()

        while dir and dir ~= "" do
          local candidate = dir .. "/node_modules/.bin/" .. binary
          if vim.fn.executable(candidate) == 1 then
            return candidate
          end

          if dir == home then
            break
          end
          local parent = vim.fs.dirname(dir)
          if not parent or parent == dir then
            break
          end
          dir = parent
        end

        return nil
      end
      local function local_typescript_sdk(root)
        if not root then
          return nil
        end

        local dir = root
        local home = vim.loop.os_homedir()

        while dir and dir ~= "" do
          local tsserver = dir .. "/node_modules/typescript/lib/tsserver.js"
          if vim.fn.filereadable(tsserver) == 1 then
            return dir .. "/node_modules/typescript/lib"
          end

          if dir == home then
            break
          end
          local parent = vim.fs.dirname(dir)
          if not parent or parent == dir then
            break
          end
          dir = parent
        end

        return nil
      end

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
        cmd = mason_cmd("clangd", { "--background-index", "--clang-tidy" }),
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        root_markers = { "compile_commands.json", "compile_flags.txt", "CMakeLists.txt", "Makefile", "meson.build", ".git" },
      })

      lsp.config("rust_analyzer", {
        cmd = mason_cmd("rust-analyzer"),
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
        cmd = mason_cmd("lua-language-server"),
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
        cmd = mason_cmd("ruff"),
        filetypes = { "python" },
      })

      lsp.config("ty", {
        cmd = mason_cmd("ty"),
        filetypes = { "python" },
      })

      lsp.config("ocamllsp", {
        cmd = mason_cmd("ocamllsp"),
        filetypes = { "ocaml", "ocaml.interface", "ocaml.menhir", "ocaml.cram", "ocaml.ocamllex", "ocaml.ocamlyacc", "reason" },
        root_markers = { "dune-project", "dune-workspace", "dune", ".git" },
      })

      lsp.config("hls", {
        cmd = mason_cmd("haskell-language-server-wrapper"),
        filetypes = { "haskell", "lhaskell", "cabal" },
        root_markers = { "hie.yaml", "stack.yaml", "cabal.project", "package.yaml", ".git" },
        settings = {
          haskell = {
            formattingProvider = "ormolu",
          },
        },
      })

      lsp.config("vtsls", {
        cmd = mason_cmd("vtsls", { "--stdio" }),
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
        single_file_support = true,
        on_new_config = function(config, root_dir)
          local tsdk = local_typescript_sdk(root_dir)
          if tsdk then
            config.settings = config.settings or {}
            config.settings.vtsls = config.settings.vtsls or {}
            config.settings.vtsls.tsserver = vim.tbl_deep_extend("force", config.settings.vtsls.tsserver or {}, {
              tsdk = tsdk,
            })
          end
        end,
        settings = {
          vtsls = {
            experimental = {
              completion = { enableServerSideFuzzyMatch = true },
            },
            tsserver = { globalPlugins = {} },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
              parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
              parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
      })

      lsp.config("eslint", {
        cmd = mason_cmd("vscode-eslint-language-server", { "--stdio" }),
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro", "graphql" },
        root_markers = {
          "eslint.config.js",
          "eslint.config.cjs",
          "eslint.config.mjs",
          "eslint.config.ts",
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.json",
        },
        on_new_config = function(config, root_dir)
          local eslint = local_package_binary(root_dir, "eslint")
          if eslint then
            config.settings = config.settings or {}
            config.settings.nodePath = root_dir .. "/node_modules"
          end
        end,
        settings = {
          quiet = true,
          format = false,
          codeActionOnSave = {
            enable = false,
            mode = "all",
          },
          workingDirectory = { mode = "auto" },
        },
      })

      lsp.config("tailwindcss", {
        cmd = mason_cmd("tailwindcss-language-server", { "--stdio" }),
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
      })

      lsp.config("graphql", {
        cmd = mason_cmd("graphql-lsp", { "server", "-m", "stream" }),
        filetypes = { "graphql", "typescriptreact", "javascriptreact" },
      })

      lsp.config("jsonls", {
        cmd = mason_cmd("vscode-json-language-server", { "--stdio" }),
        filetypes = { "json", "jsonc" },
        init_options = { provideFormatter = false },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      lsp.config("biome", {
        cmd = mason_cmd("biome", { "lsp-proxy" }),
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "json",
          "jsonc",
          "css",
        },
        root_markers = { "biome.json", "biome.jsonc" },
      })

      lsp.config("yamlls", {
        cmd = mason_cmd("yaml-language-server", { "--stdio" }),
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
        cmd = mason_cmd("dockerfile-language-server-nodejs", { "--stdio" }),
        filetypes = { "dockerfile" },
      })

      lsp.config("docker_compose_language_service", {
        cmd = mason_cmd("docker-compose-langserver", { "--stdio" }),
        filetypes = { "yaml.docker-compose" },
      })

      lsp.config("texlab", {
        cmd = mason_cmd("texlab"),
        filetypes = { "tex", "plaintex", "bib" },
      })

      -- Enable Mason-installable servers
      local mason_servers = {
        { name = "clangd", binary = "clangd" },
        { name = "rust_analyzer", binary = "rust-analyzer" },
        { name = "lua_ls", binary = "lua-language-server" },
        { name = "ruff", binary = "ruff" },
        { name = "ty", binary = "ty" },
        { name = "ocamllsp", binary = "ocamllsp" },
        { name = "hls", binary = "haskell-language-server-wrapper" },
        { name = "vtsls", binary = "vtsls" },
        { name = "biome", binary = "biome" },
        { name = "eslint", binary = "vscode-eslint-language-server" },
        { name = "tailwindcss", binary = "tailwindcss-language-server" },
        { name = "graphql", binary = "graphql-lsp" },
        { name = "jsonls", binary = "vscode-json-language-server" },
        { name = "yamlls", binary = "yaml-language-server" },
        { name = "dockerls", binary = "dockerfile-language-server-nodejs" },
        { name = "docker_compose_language_service", binary = "docker-compose-langserver" },
        { name = "texlab", binary = "texlab" },
      }

      for _, server in ipairs(mason_servers) do
        if available_binary(server.binary) then
          lsp.enable(server.name)
        end
      end

      -- Non-Mason servers (conditionally enabled if binary exists)
      local conditional_servers = {
        { name = "millet", cmd = "millet-ls", config = { filetypes = { "sml", "mlb" } } },
        { name = "racket_langserver", cmd = "racket", config = { cmd = { "racket", "--lib", "racket-langserver" }, filetypes = { "racket", "scheme" } } },
        { name = "coq_lsp", cmd = "coq-lsp", config = { filetypes = { "coq" } } },
        { name = "lean4", cmd = "lean", config = { filetypes = { "lean" } } },
        { name = "als", cmd = "als", config = { filetypes = { "ada" } } },
        {
          name = "rescriptls",
          cmd = "rescript-language-server",
          config = {
            cmd = { "rescript-language-server", "--stdio" },
            filetypes = { "rescript" },
            root_markers = { "rescript.json", "bsconfig.json", "package.json", ".git" },
          },
        },
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
          vim.keymap.set("n", "<leader>lr", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
          end, { buffer = event.buf, expr = true, desc = "LSP: Rename (live preview)" })
          map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
          map("<leader>ls", vim.lsp.buf.signature_help, "Signature help")
          map("<leader>ci", function() apply_code_action("source.organizeImports") end, "Organize imports")
          map("<leader>cI", function() apply_code_action("source.addMissingImports") end, "Add missing imports")
          map("<leader>cu", function() apply_code_action("source.removeUnused") end, "Remove unused imports")
          map("<leader>cF", function() apply_code_action("source.fixAll") end, "Fix all auto-fixable issues")
          map("<leader>cE", function() apply_code_action("source.fixAll.eslint") end, "Fix ESLint issues")
          map("<leader>lR", function()
            local clients = vim.lsp.get_clients({ bufnr = event.buf })
            for _, attached_client in ipairs(clients) do
              attached_client:stop(true)
            end
            vim.defer_fn(function()
              vim.cmd("edit")
            end, 100)
          end, "Restart LSP clients")

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

          if client and client.name == "eslint" then
            vim.diagnostic.config({
              virtual_text = {
                severity = { min = vim.diagnostic.severity.ERROR },
              },
              signs = true,
              underline = true,
              severity_sort = true,
            }, event.buf)
          end
        end,
      })
    end,
  },
}

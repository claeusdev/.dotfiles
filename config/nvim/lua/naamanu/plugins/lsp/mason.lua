return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    mason.setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "ts_ls",          -- TypeScript
        "rust_analyzer",  -- Rust
        "gopls",          -- Go
        "clangd",         -- C/C++
        "lua_ls",         -- Lua
        "bashls",         -- Bash
        "jsonls",         -- JSON
        "yamlls",         -- YAML
        "ocamllsp",       -- OCaml
        "hls",            -- Haskell
        "elmls",          -- Elm
        "rescriptls",     -- ReScript
      },
      automatic_installation = true,
    })
  end,
}

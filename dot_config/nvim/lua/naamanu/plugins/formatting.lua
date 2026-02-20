return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      c = { "clang-format" },
      cpp = { "clang-format" },
      rust = { "rustfmt" },
      ocaml = { "ocamlformat" },
      python = { "ruff_fix", "ruff_format" },
      haskell = { "ormolu" },
      nix = { "nixfmt" },
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 3000,
      lsp_fallback = true,
    },
    formatters = {
      ocamlformat = {
        prepend_args = function(_, ctx)
          if ctx.filename and ctx.filename:match("%.mli$") then
            return { "--intf" }
          end
          return { "--impl" }
        end,
      },
    },
  },
}

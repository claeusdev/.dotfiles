local function biome_or_prettier(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local start = path ~= "" and vim.fs.dirname(path) or vim.fn.getcwd()
  if vim.fs.find({ "biome.json", "biome.jsonc" }, { upward = true, path = start })[1] then
    return { "biome" }
  end
  return { "prettier" }
end

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
      json = biome_or_prettier,
      jsonc = biome_or_prettier,
      yaml = { "prettier" },
      markdown = { "prettier" },
      typescript = biome_or_prettier,
      typescriptreact = biome_or_prettier,
      javascript = biome_or_prettier,
      javascriptreact = biome_or_prettier,
      html = { "prettier" },
      css = biome_or_prettier,
      graphql = { "prettier" },
      ruby = { "rubocop" },
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

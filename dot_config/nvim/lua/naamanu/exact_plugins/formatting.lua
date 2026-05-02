local js_like_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  vue = true,
  svelte = true,
  astro = true,
}

local function biome_or_prettier(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local tasks = require("naamanu.core.tasks")

  if tasks.biome_config_root(path) then
    return { "biome" }
  end
  if tasks.prettier_config_root(path) then
    return { "prettier" }
  end

  return {}
end

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = false })
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
      vue = biome_or_prettier,
      svelte = biome_or_prettier,
      astro = biome_or_prettier,
      html = { "prettier" },
      css = biome_or_prettier,
      scss = biome_or_prettier,
      graphql = { "prettier" },
    },
    format_on_save = function(bufnr)
      return {
        timeout_ms = 3000,
        lsp_fallback = not js_like_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters = {
      biome = {
        command = function(_, ctx)
          local tasks = require("naamanu.core.tasks")
          return tasks.local_package_binary("biome", ctx.filename) or "biome"
        end,
      },
      prettier = {
        command = function(_, ctx)
          local tasks = require("naamanu.core.tasks")
          return tasks.local_package_binary("prettier", ctx.filename) or "prettier"
        end,
      },
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

return {
  "lervag/vimtex",
  ft = { "tex", "latex", "bib" },
  init = function()
    -- PDF viewer: Skim on macOS, zathura on Linux
    if vim.fn.has("mac") == 1 then
      vim.g.vimtex_view_method = "skim"
    else
      vim.g.vimtex_view_method = "zathura"
    end

    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_quickfix_mode = 0

    -- Disable default mappings, use <localleader>l prefix (localleader = ,)
    vim.g.vimtex_mappings_prefix = "<localleader>l"
  end,
}

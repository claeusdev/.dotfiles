return {
  -- Molten: Jupyter notebook integration in Neovim
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    ft = { "python", "markdown" },
    dependencies = {
      "3rd/image.nvim",
    },
    init = function()
      vim.filetype.add({
        extension = {
          ipy = "python",
        },
      })
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_image_location = "both"
      vim.g.molten_output_win_max_height = 24
      vim.g.molten_auto_open_output = true
      vim.g.molten_enter_output_behavior = "open_then_enter"
      vim.g.molten_output_virt_lines = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_tick_rate = 200
      vim.g.molten_limit_output_chars = 200000
      vim.g.molten_output_show_more = true
    end,
    keys = {
      { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Molten: Init" },
      { "<leader>mI", "<cmd>MoltenInfo<cr>", desc = "Molten: Info" },
      { "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "Molten: Eval operator" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Molten: Eval line" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Molten: Re-eval cell" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Molten: Delete cell" },
      { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "Molten: Show output" },
      { "<leader>mO", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Molten: Enter output" },
      { "<leader>mH", "<cmd>MoltenHideOutput<cr>", desc = "Molten: Hide output" },
      { "<leader>mn", "<cmd>MoltenNext<cr>", desc = "Molten: Next cell" },
      { "<leader>mp", "<cmd>MoltenPrev<cr>", desc = "Molten: Previous cell" },
      { "<leader>mx", "<cmd>MoltenInterrupt<cr>", desc = "Molten: Interrupt" },
      { "<leader>mR", "<cmd>MoltenRestart<cr>", desc = "Molten: Restart kernel" },
      { "<leader>mX", "<cmd>MoltenExportOutput<cr>", desc = "Molten: Export output" },
      { "<leader>mL", "<cmd>MoltenImportOutput<cr>", desc = "Molten: Import output" },
      { "<leader>mv", ":<C-u>MoltenEvaluateVisual<cr>gv", desc = "Molten: Eval selection", mode = "v" },
    },
  },
}

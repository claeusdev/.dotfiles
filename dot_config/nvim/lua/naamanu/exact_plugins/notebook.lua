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
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
    end,
    keys = {
      { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Molten: Init" },
      { "<leader>me", "<cmd>MoltenEvaluateOperator<cr>", desc = "Molten: Eval operator" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Molten: Eval line" },
      { "<leader>mr", "<cmd>MoltenReevaluateCell<cr>", desc = "Molten: Re-eval cell" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Molten: Delete cell" },
      { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "Molten: Show output" },
    },
  },
}

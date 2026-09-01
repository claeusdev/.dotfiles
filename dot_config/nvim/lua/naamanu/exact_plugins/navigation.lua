return {
	-- Oil (file explorer)
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		opts = {
			default_file_explorer = true,
			columns = { "icon" },
			view_options = {
				show_hidden = true,
			},
		},
		keys = {
			{ "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
			{ "<leader>E", "<cmd>Oil<CR>", desc = "File explorer (Oil)" },
		},
	},

	-- Picker: snacks.picker (fragment merged into the main snacks.nvim spec).
	-- ui_select is on by default once the picker is enabled, so code actions
	-- and other vim.ui.select prompts render as pickers too.
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				enabled = true,
				ui_select = true,
				sources = {
					files = { hidden = true },
				},
			},
		},
		keys = {
			{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
			{
				"<leader>fp",
				function()
					if vim.fs.root(0, ".git") then
						Snacks.picker.git_files({ untracked = true })
					else
						Snacks.picker.files()
					end
				end,
				desc = "Project files",
			},
			{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
			{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
			{ "<leader>f/", function() Snacks.picker.lines() end, desc = "Search current buffer" },
			{ "<leader>f.", function() Snacks.picker.resume() end, desc = "Resume last picker" },
			{ "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Find string under cursor", mode = { "n", "x" } },
			{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
			{ "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
			{ "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
			{ "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
			{ "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
			{ "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
		},
	},
}

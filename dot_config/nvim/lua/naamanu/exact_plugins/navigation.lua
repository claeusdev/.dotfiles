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
			{ "<leader>e", "<cmd>Oil<CR>", desc = "File explorer (Oil)" },
		},
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
			{
				"<leader>fp",
				function()
					local builtin = require("telescope.builtin")
					local ok = pcall(builtin.git_files, { show_untracked = true })
					if not ok then
						builtin.find_files({ hidden = true })
					end
				end,
				desc = "Project files",
			},
			{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
			{ "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search current buffer" },
			{ "<leader>f.", "<cmd>Telescope resume<CR>", desc = "Resume last picker" },
			{ "<leader>fc", "<cmd>Telescope grep_string<CR>", desc = "Find string under cursor" },
			{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
			{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
			{ "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
			{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
			{ "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					path_display = { "truncate" },
				},
				pickers = {
					find_files = {
						hidden = true,
						file_ignore_patterns = { "%.git/" },
					},
					git_files = {
						show_untracked = true,
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
		end,
	},
}

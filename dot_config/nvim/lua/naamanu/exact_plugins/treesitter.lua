-- Parsers this config expects; anything missing is installed on startup.
local ensure_installed = {
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"dockerfile",
	"fish",
	"go",
	"haskell",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"ocaml",
	"ocaml_interface",
	"python",
	"query",
	"racket",
	"regex",
	"rust",
	"sql",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

return {
	-- Treesitter.  The `main` branch is the maintained rewrite: setup() only
	-- takes install_dir, parsers are installed explicitly, and highlighting
	-- is started per buffer via vim.treesitter.start.  The old master-branch
	-- module options (highlight/indent/incremental_selection) do not exist.
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup({})

			local installed = require("nvim-treesitter.config").get_installed("parsers")
			local missing = vim.tbl_filter(function(lang)
				return not vim.list_contains(installed, lang)
			end, ensure_installed)
			if #missing > 0 then
				ts.install(missing)
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
				callback = function(ev)
					if pcall(vim.treesitter.start, ev.buf) then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})

			-- The main branch dropped incremental_selection; flash's
			-- treesitter mode is the label-based replacement.
			vim.keymap.set({ "n", "x" }, "<C-space>", function()
				require("flash").treesitter()
			end, { desc = "Treesitter selection" })
		end,
	},

	-- Treesitter text objects (new API)
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			-- select
			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end)

			-- move
			vim.keymap.set({ "n", "x", "o" }, "]f", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]c", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[f", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[c", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
			end)
		end,
	},

	-- Auto-close/rename HTML and JSX tags
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},

	-- Treesitter context (sticky headers)
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			max_lines = 3,
		},
	},
}

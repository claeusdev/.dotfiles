return {
	-- Mason (tool installer)
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		opts = {
			ui = { border = "rounded" },
		},
	},

	-- Mason tool installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSP servers
				"clangd",
				"rust-analyzer",
				"lua-language-server",
				"ruff",
				"basedpyright",
				"ocaml-lsp",
				"haskell-language-server",
				"vtsls",
				"eslint-lsp",
				"tailwindcss-language-server",
				"css-lsp",
				"json-lsp",
				"yaml-language-server",
				-- Formatters
				"stylua",
				"shfmt",
				"prettier",
				"sql-formatter",
				"ormolu",
				-- Linters
				"shellcheck",
			},
		},
	},

	-- Fidget (LSP progress)
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {},
	},

	-- Lazydev (Lua/Neovim API completions)
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	-- Live-preview LSP rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		opts = {},
	},

	-- JSON/YAML schema catalog, consumed by core/lsp.lua (which is where the
	-- native vim.lsp.config/enable setup lives, required from core/init.lua).
	{ "b0o/schemastore.nvim", lazy = true },
}

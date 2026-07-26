-- Native LSP configuration via vim.lsp.config/enable (no nvim-lspconfig).
-- Required from core/init.lua after lazy.nvim is set up, so requiring
-- lazy-loaded plugin modules (schemastore) works here.
--
-- NOTE: this is the native API — nvim-lspconfig concepts like
-- `on_new_config` and `single_file_support` do not exist and are silently
-- ignored; the native equivalent of single-file support is the default
-- `workspace_required = false`.

local lsp = vim.lsp
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

local function mason_binary(binary)
	local candidate = mason_bin .. "/" .. binary
	return vim.fn.executable(candidate) == 1 and candidate or nil
end

local function available_binary(binary)
	return mason_binary(binary) or (vim.fn.exepath(binary) ~= "" and vim.fn.exepath(binary) or nil)
end

local function mason_cmd(binary, extra_args)
	local executable = available_binary(binary)
	if not executable then
		return nil
	end

	return vim.list_extend({ executable }, extra_args or {})
end

local function apply_code_action(kind)
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			only = { kind },
			diagnostics = {},
		},
	})
end

-- Diagnostic config
vim.diagnostic.config({
	virtual_text = { spacing = 4, prefix = "●" },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded" },
})

-- Mason-installable servers
lsp.config("clangd", {
	cmd = mason_cmd("clangd", { "--background-index", "--clang-tidy" }),
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = {
		"compile_commands.json",
		"compile_flags.txt",
		"CMakeLists.txt",
		"Makefile",
		"meson.build",
		".git",
	},
})

lsp.config("rust_analyzer", {
	cmd = mason_cmd("rust-analyzer"),
	filetypes = { "rust" },
	settings = {
		["rust-analyzer"] = {
			checkOnSave = true,
			check = { command = "clippy" },
			cargo = { allFeatures = true },
			inlayHints = {
				bindingModeHints = { enable = true },
				closureReturnTypeHints = { enable = "always" },
				lifetimeElisionHints = { enable = "always" },
			},
		},
	},
})

lsp.config("lua_ls", {
	cmd = mason_cmd("lua-language-server"),
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			hint = { enable = true },
		},
	},
})

lsp.config("ruff", {
	cmd = mason_cmd("ruff", { "server" }),
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", "uv.lock", "requirements.txt", ".git" },
})

-- basedpyright matches the Emacs setup, so both editors report the same
-- Python diagnostics.  ruff owns imports and formatting.
lsp.config("basedpyright", {
	cmd = mason_cmd("basedpyright-langserver", { "--stdio" }),
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "uv.lock", ".git" },
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			analysis = {
				autoImportCompletions = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
})

lsp.config("ocamllsp", {
	cmd = mason_cmd("ocamllsp"),
	filetypes = {
		"ocaml",
		"ocaml.interface",
		"ocaml.menhir",
		"ocaml.cram",
		"ocaml.ocamllex",
		"ocaml.ocamlyacc",
		"reason",
	},
	root_markers = { "dune-project", "dune-workspace", "dune", ".git" },
})

lsp.config("hls", {
	cmd = mason_cmd("haskell-language-server-wrapper"),
	filetypes = { "haskell", "lhaskell", "cabal" },
	root_markers = { "hie.yaml", "stack.yaml", "cabal.project", "package.yaml", ".git" },
	settings = {
		haskell = {
			formattingProvider = "ormolu",
		},
	},
})

lsp.config("vtsls", {
	cmd = mason_cmd("vtsls", { "--stdio" }),
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	settings = {
		vtsls = {
			-- Use the project's own typescript from node_modules when present,
			-- so editor diagnostics agree with `tsc`.
			autoUseWorkspaceTsdk = true,
			experimental = {
				completion = { enableServerSideFuzzyMatch = true },
			},
			tsserver = { globalPlugins = {} },
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			inlayHints = {
				parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
		javascript = {
			updateImportsOnFileMove = { enabled = "always" },
			inlayHints = {
				parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
	},
})

lsp.config("eslint", {
	cmd = mason_cmd("vscode-eslint-language-server", { "--stdio" }),
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
	root_markers = {
		"eslint.config.js",
		"eslint.config.cjs",
		"eslint.config.mjs",
		"eslint.config.ts",
		".eslintrc",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.json",
	},
	settings = {
		run = "onSave",
		quiet = true,
		format = false,
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		workingDirectory = { mode = "auto" },
	},
})

lsp.config("tailwindcss", {
	cmd = mason_cmd("tailwindcss-language-server", { "--stdio" }),
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
})

lsp.config("cssls", {
	cmd = mason_cmd("vscode-css-language-server", { "--stdio" }),
	filetypes = { "css", "scss", "less" },
	init_options = { provideFormatter = false },
})

lsp.config("jsonls", {
	cmd = mason_cmd("vscode-json-language-server", { "--stdio" }),
	filetypes = { "json", "jsonc" },
	init_options = { provideFormatter = false },
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

lsp.config("yamlls", {
	cmd = mason_cmd("yaml-language-server", { "--stdio" }),
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	settings = {
		yaml = {
			schemaStore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas(),
			validate = { enable = true },
		},
	},
})

-- Enable servers whose binary is present (mason bin first, then PATH), so a
-- missing tool degrades silently instead of erroring.
local mason_servers = {
	{ name = "clangd", binary = "clangd" },
	{ name = "rust_analyzer", binary = "rust-analyzer" },
	{ name = "lua_ls", binary = "lua-language-server" },
	{ name = "ruff", binary = "ruff" },
	{ name = "basedpyright", binary = "basedpyright-langserver" },
	{ name = "ocamllsp", binary = "ocamllsp" },
	{ name = "hls", binary = "haskell-language-server-wrapper" },
	{ name = "vtsls", binary = "vtsls" },
	{ name = "eslint", binary = "vscode-eslint-language-server" },
	{ name = "tailwindcss", binary = "tailwindcss-language-server" },
	{ name = "cssls", binary = "vscode-css-language-server" },
	{ name = "jsonls", binary = "vscode-json-language-server" },
	{ name = "yamlls", binary = "yaml-language-server" },
}

for _, server in ipairs(mason_servers) do
	if available_binary(server.binary) then
		lsp.enable(server.name)
	end
end

-- LspAttach keybindings
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("gD", vim.lsp.buf.declaration, "Go to declaration")
		map("gr", vim.lsp.buf.references, "Go to references")
		map("gi", vim.lsp.buf.implementation, "Go to implementation")
		map("gt", vim.lsp.buf.type_definition, "Go to type definition")
		map("K", vim.lsp.buf.hover, "Hover documentation")
		map("<leader>la", vim.lsp.buf.code_action, "Code action")
		vim.keymap.set("n", "<leader>lr", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, { buffer = event.buf, expr = true, desc = "LSP: Rename (live preview)" })
		map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
		map("<leader>ls", vim.lsp.buf.signature_help, "Signature help")
		map("<leader>ci", function()
			apply_code_action("source.organizeImports")
		end, "Organize imports")
		map("<leader>cI", function()
			apply_code_action("source.addMissingImports")
		end, "Add missing imports")
		map("<leader>cu", function()
			apply_code_action("source.removeUnused")
		end, "Remove unused imports")
		map("<leader>cF", function()
			apply_code_action("source.fixAll")
		end, "Fix all auto-fixable issues")
		map("<leader>cE", function()
			apply_code_action("source.fixAll.eslint")
		end, "Fix ESLint issues")
		map("<leader>lR", function()
			local clients = vim.lsp.get_clients({ bufnr = event.buf })
			for _, attached_client in ipairs(clients) do
				attached_client:stop(true)
			end
			vim.defer_fn(function()
				vim.cmd("edit")
			end, 100)
		end, "Restart LSP clients")

		-- Inlay hints (Neovim 0.10+)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/inlayHint", event.buf) then
			vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
			map("<leader>lh", function()
				vim.lsp.inlay_hint.enable(
					not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
					{ bufnr = event.buf }
				)
			end, "Toggle inlay hints")
		end

		-- Code lens
		if client and client:supports_method("textDocument/codeLens", event.buf) then
			map("<leader>lc", vim.lsp.codelens.run, "Run code lens")
			map("<leader>lC", function()
				vim.lsp.codelens.enable(true, { bufnr = event.buf })
			end, "Enable code lens")
			vim.lsp.codelens.enable(true, { bufnr = event.buf })
		end

		if client and client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end
	end,
})

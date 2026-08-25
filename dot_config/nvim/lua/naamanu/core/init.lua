-- Load core modules in order
require("naamanu.core.options")
require("naamanu.core.keymaps")
require("naamanu.core.autocmds")
require("naamanu.core.lazy")
require("naamanu.core.lsp") -- native vim.lsp.config/enable; needs lazy for schemastore

require("naamanu.core.workflows")

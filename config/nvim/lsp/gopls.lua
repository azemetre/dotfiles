local util = require("lspconfig.util")
local async = require("lspconfig.async")
local mod_cache = nil

return {
	default_config = {
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		root_markers = {
			"go.mod",
			"go.sum",
		},
		single_file_support = true,
	},
	docs = {
		description = [[
https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.
]],
	},
}

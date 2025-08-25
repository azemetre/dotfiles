---@type vim.lsp.Config
return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = {
		"go.mod",
		"go.sum",
		".git", -- git
		".hg", -- mercurial
		".svn", -- subversion
		".bzr", -- bazaar
	},
	single_file_support = true,
	docs = {
		description = [[
https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.
]],
	},
}

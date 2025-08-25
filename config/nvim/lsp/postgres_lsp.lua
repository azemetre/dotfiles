---@type vim.lsp.Config
return {
	default_config = {
		cmd = { "postgrestools", "lsp-proxy" },
		filetypes = {
			"sql",
		},
		root_markers = {
			"postgrestools.jsonc",
			".git", -- git
			".hg", -- mercurial
			".svn", -- subversion
			".bzr", -- bazaar
		},
		single_file_support = true,
	},
	docs = {
		description = [[
https://pgtools.dev

A collection of language tools and a Language Server Protocol (LSP) implementation for Postgres, focusing on developer experience and reliable SQL tooling.
        ]],
	},
}

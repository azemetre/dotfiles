---@brief
---
--- https://github.com/yioneko/vtsls
---
--- `vtsls` can be installed with npm:
--- ```sh
--- npm install -g @vtsls/language-server
--- ```
---@type vim.lsp.Config
return {
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = {
		"tsconfig.json",
		"package.json",
		"jsconfig.json",
		".git", -- git
		".hg", -- mercurial
		".svn", -- subversion
		".bzr", -- bazaar
	},
}

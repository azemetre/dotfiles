---@brief
---
--- https://github.com/iamcco/vim-language-server
---
--- #npm
--- ```sh
--- npm install -g vim-language-server
--- ```
--- #TODO: include instructions to install snippets
--- ```
return {
	cmd = { "vim-language-server", "--stdio" },
	filetypes = { "vim" },
	root_markers = {
		".git", -- git
		".hg", -- mercurial
		".svn", -- subversion
		".bzr", -- bazaar
	},
	init_options = {
		isNeovim = true,
		iskeyword = "@,48-57,_,192-255,-#",
		vimruntime = "",
		runtimepath = "",
		diagnostic = { enable = true },
		indexes = {
			runtimepath = true,
			gap = 100,
			count = 3,
			projectRootPatterns = {
				"runtime",
				"nvim",
				".git",
				"autoload",
				"plugin",
			},
		},
		suggest = { fromVimruntime = true, fromRuntimepath = true },
	},
}

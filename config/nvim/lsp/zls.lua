---@brief
---
--- https://github.com/zigtools/zls
---
--- #osx #mac #homebrew
--- ```sh
--- brew install zls
--- brew install zig
--- ```
--- #TODO: include instructions to install snippets
--- ```
return {
	default_config = {
		cmd = { "zls" },
		on_new_config = function(new_config, new_root_markers)
			if
				vim.fn.filereadable(vim.fs.joinpath(new_root_markers, "zls.json"))
				~= 0
			then
				new_config.cmd = { "zls", "--config-path", "zls.json" }
			end
		end,
		filetypes = { "zig", "zir" },
		root_markers = {
			"zls.json",
			"build.zig",
			".git", -- git
			".hg", -- mercurial
			".svn", -- subversion
			".bzr", -- bazaar
		},
		single_file_support = true,
	},
	docs = {
		description = [[
https://github.com/zigtools/zls

Zig LSP implementation + Zig Language Server
        ]],
	},
}

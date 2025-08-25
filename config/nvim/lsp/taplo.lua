---@brief
---
--- https://github.com/tamasfe/taplo
---
--- #osx #mac #homebrew
--- ```sh
--- brew install taplo
--- ```
--- #TODO: include instructions to install snippets
--- ```
---@type vim.lsp.Config
return {
	cmd = { "taplo", "lsp", "stdio" },
	filetypes = { "toml" },
	root_markers = {
		".git", -- git
		".hg", -- mercurial
		".svn", -- subversion
		".bzr", -- bazaar
	},
	single_file_support = true,
	docs = {
		description = [[
https://taplo.tamasfe.dev/cli/usage/language-server.html

Language server for Taplo, a TOML toolkit.

`taplo-cli` can be installed via `cargo`:
```sh
cargo install --features lsp --locked taplo-cli
```
    ]],
	},
}

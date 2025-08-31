---@brief
--- https://biomejs.dev
---
--- Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).
---
--- ```sh
--- npm install [-g] @biomejs/biome
--- ```
---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		local cmd = "biome"

		local root_dir = config and config.root_dir
		if root_dir then
			local local_cmd = root_dir .. "/node_modules/.bin/biome"
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end

		return vim.lsp.rpc.start({ cmd, "lsp-proxy" }, dispatchers)
	end,
	filetypes = {
		"astro",
		"css",
		"graphql",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"jsonc",
		"svelte",
		"typescript",
		"typescript.tsx",
		"typescriptreact",
		"vue",
	},
	workspace_required = true,
	root_markers = {
		"biome.json",
		"biome.jsonc",
		".git", -- git
		".hg", -- mercurial
		".svn", -- subversion
		".bzr", -- bazaar
	},
}

-- #language #core #lsp #syntax-highlight
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "BufReadPost",
	---@type TSConfig
	opts = {
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },
		context_commentstring = { enable = true, enable_autocmd = false },
		ensure_installed = {
			"bash",
			"cmake",
			"css",
			"dockerfile",
			"go",
			"gomod",
			"html",
			"javascript",
			-- "jsdoc",
			"json",
			"json5",
			"lua",
			"markdown",
			"markdown_inline",
			"python",
			"rust",
			"scss",
			"toml",
			"typescript",
			"tsx",
			"vim",
			"zig",
		},
	},
	---@param opts TSConfig
	config = function(plugin, opts)
		if plugin.ensure_installed then
			require("enchiridion.util").deprecate(
				"treesitter.ensure_installed",
				"treesitter.opts.ensure_installed"
			)
		end
		require("nvim-treesitter.configs").setup(opts)
	end,
}

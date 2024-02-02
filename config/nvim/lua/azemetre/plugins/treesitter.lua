return {
	{
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
				"c",
				"cmake",
				"css", -- possible trojan installed, refer to \
				-- https://github.com/tree-sitter/tree-sitter-css/issues/35
				"dockerfile",
				"go",
				"gomod",
				"html",
				"javascript",
				-- "jsdoc",
				"json",
				"json5",
				"kotlin",
				"lua",
				"markdown",
				"php",
				"python",
				"rust",
				"scss",
				"svelte",
				"toml",
				"typescript",
				"vim",
			},
		},
		---@param opts TSConfig
		config = function(plugin, opts)
			if plugin.ensure_installed then
				require("azemetre.util").deprecate(
					"treesitter.ensure_installed",
					"treesitter.opts.ensure_installed"
				)
			end
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		opts = {
			-- Enable this plugin (Can be enabled/disabled later via commands)
			enable = true,
			-- Throttles plugin updates (may improve performance)
			throttle = true,
			-- How many lines the window should span. Values <= 0 mean no limit
			max_lines = 0,
			show_all_context = true,
			-- Match patterns for TS nodes. These get wrapped to match at word
			-- boundaries.
			patterns = {
				-- For all filetypes
				-- Note that setting an entry here replaces all other patterns
				-- for this entry. By setting the 'default' entry below, you
				-- can control which nodes you want to appear in the context
				-- window.
				default = {
					"class",
					"function",
					"method",
					"for",
					"while",
					"if",
					"switch",
					"case",
					"interface",
					"struct",
					"enum",
				},
				json = {
					"pair",
				},
				markdown = {
					"section",
				},
				rust = {
					"loop_expression",
					"impl_item",
				},
				terraform = {
					"block",
					"object_elem",
					"attribute",
				},
				typescript = {
					"class_declaration",
					"abstract_class_declaration",
					"else_clause",
				},
				yaml = {
					"block_mapping_pair",
				},
			},
		},
	},
}

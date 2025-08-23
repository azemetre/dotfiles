-- #ux #text #lsp #treesitter
-- laundry - folding clothes
return {
	dir = "shimman-dev/laundry.nvim",
	priority = 1000,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = { "BufReadPost", "BufNewFile" },
	---@module 'laundry'
	---@type LaundryConfig
	opts = {
		auto_fold = true,
		min_fold_lines = 20,
	},
}

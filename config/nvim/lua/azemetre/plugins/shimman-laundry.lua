return {
	-- laundry - folding clothes
	{
		dir = "~/github/laundry.nvim",
		dev = true,
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
	},
}

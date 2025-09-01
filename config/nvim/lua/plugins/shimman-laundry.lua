-- #ux #text #lsp #treesitter
-- laundry - folding clothes
---@type Utils.Pack.Spec
return {
	src = "https://github.com/shimman-dev/laundry.nvim",
	defer = true,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/nvim-treesitter/nvim-treesitter",
		},
	},
	config = function()
		local laundry = require("laundry")
		---@type LaundryConfig
		local opts = {
			auto_fold = true,
			min_fold_lines = 20,
		}
		laundry.setup(opts)
	end,
}

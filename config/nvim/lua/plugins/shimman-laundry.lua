-- #ux #text #lsp #treesitter
-- laundry - folding clothes
---@type Utils.Pack.Spec
return {
	src = "https://github.com/shimman-dev/laundry.nvim",
	defer = true,
	dependencies = {
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	},
	---@module 'laundry'
	---@type LaundryConfig
	config = function()
		require("laundry").setup({
			auto_fold = true,
			min_fold_lines = 20,
		})
	end,
}

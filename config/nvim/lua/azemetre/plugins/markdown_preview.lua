return {
	-- #docs #markdown #notes #documentation
	-- markdown preview
	{
		"iamcco/markdown-preview.nvim",
		even = "VeryLazy",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}

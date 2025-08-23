-- #colorscheme #theme #color
-- for housing multiple color schemes
return {
	-- tokyonight
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = { style = "storm" },
		config = function(_, opts)
			local tokyonight = require("tokyonight")
			tokyonight.setup(opts)
			tokyonight.load()
		end,
	},

	-- eekah - collection of color schemes
	{
		dir = "shimman-dev/eekah.nvim",
		dev = true,
		lazy = false,
		priority = 1000,
	},
}

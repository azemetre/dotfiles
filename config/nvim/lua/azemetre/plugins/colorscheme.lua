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

	-- hipster
	{
		"azemetre/hipster.nvim",
		lazy = false,
		priority = 1000,
		dependencies = { "rktjmp/lush.nvim" },
	},

	-- oink's pink palace
	{
		dir = "~/github/oink.nvim",
		dev = true,
		lazy = false,
		priority = 1000,
	},

	-- noctis
	{
		"talha-akram/noctis.nvim",
		priority = 1000,
	},

	-- poimandres
	{
		"olivercederborg/poimandres.nvim",
		priority = 1000,
	},

	-- nightfox
	-- duskfox is decent looking
	{
		"EdenEast/nightfox.nvim",
		priority = 1000,
	},

	-- catppuccin
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
}

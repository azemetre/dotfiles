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
}

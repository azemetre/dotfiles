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

	-- hipster
	{
		-- "enchiridion/hipster.nvim",
		-- dependencies = { "rktjmp/lush.nvim" },
		dir = "~/github/hipster.nvim",
		dev = true,
		lazy = false,
		priority = 1000,
		-- config = function(_, opts)
		-- 	local hipster = require("hipster")
		-- 	hipster.setup(opts)
		-- 	hipster.load()
		-- end,
	},

	-- oink's pink palace
	{
		dir = "~/github/oink.nvim",
		dev = true,
		lazy = false,
		priority = 1000,
	},
}

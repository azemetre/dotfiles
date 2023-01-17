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

	-- noctis
	{
		"talha-akram/noctis.nvim",
		priority = 1000,
	},

  -- catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
}

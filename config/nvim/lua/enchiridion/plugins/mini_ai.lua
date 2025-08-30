-- #editor #ui #vim-motion
-- better text-objects
---@type Utils.Pack.Spec
return {
	src = "https://github.com/nvim-mini/mini.ai",
	dependencies = {
		{
			src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		},
	},
	config = function()
		local ai = require("mini.ai")
		ai.setup({
			n_lines = 500,
			custom_textobjects = {
				o = ai.gen_spec.treesitter({
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}, {}),
				f = ai.gen_spec.treesitter(
					{ a = "@function.outer", i = "@function.inner" },
					{}
				),
				c = ai.gen_spec.treesitter(
					{ a = "@class.outer", i = "@class.inner" },
					{}
				),
			},
		})
	end,
}

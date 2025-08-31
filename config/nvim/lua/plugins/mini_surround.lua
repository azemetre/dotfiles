-- #editor #keyboard
-- surround
---@type Utils.Pack.Spec
return {
	src = "https://github.com/echasnovski/mini.surround",
	defer = true,
	config = function()
		require("mini.surround").setup({
			mappings = {
				add = "gza",
				delete = "gzd",
				find = "gzf",
				find_left = "gzF",
				highlight = "gzh",
				replace = "gzr",
				update_n_lines = "gzn",
			},
		})
	end,
}

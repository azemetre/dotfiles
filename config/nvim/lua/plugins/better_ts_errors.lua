-- #ui #editor #typescript #ts #frontend
----@type Utils.Pack.Spec
return {
	src = "https://github.com/OlegGulevskyy/better-ts-errors.nvim",
	defer = true,
	config = function()
		require("better-ts-errors").setup({
			keymaps = {
				toggle = "<leader>dd",
				go_to_definition = "<leader>dx",
			},
		})
	end,
}

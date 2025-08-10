return {
	-- indent guides for Neovim
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "BufReadPre",
		config = function()
			local ibl = require("ibl")
			ibl.setup({
				indent = {
					char = "|",
				},
				exclude = {
					filetypes = {
						"help",
						"alpha",
						"dashboard",
						"neo-tree",
						"lazy",
						"Trouble",
					},
				},
				whitespace = {
					remove_blankline_trail = false,
				},
				scope = {
					enabled = false,
				},
			})
		end,
	},
}

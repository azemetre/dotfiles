-- #editor #search
-- better diagnostics list and others
---@type Utils.Pack.Spec
return {
	src = "https://github.com/folke/trouble.nvim",
	defer = true,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/nvim-tree/nvim-web-devicons",
		},
	},
	config = function()
		require("trouble").setup({
			use_diagnostic_signs = true,
		})

		vim.keymap.set(
			"n",
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			{ desc = "Document Diagnostics (Trouble)" }
		)
		vim.keymap.set(
			"n",
			"<leader>xq",
			"<cmd>Trouble quickfix toggle<cr>",
			{ desc = "Quickfix (Trouble)" }
		)
	end,
}

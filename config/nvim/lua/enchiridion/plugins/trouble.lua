-- #editor #search
-- better diagnostics list and others
return {
	"folke/trouble.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	cmd = { "TroubleToggle", "Trouble" },
	opts = { use_diagnostic_signs = true },
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Document Diagnostics (Trouble)",
		},
		{
			"<leader>xq",
			"<cmd>Trouble quickfix toggle<cr>",
			desc = "Quickfix (Trouble)",
		},
	},
}

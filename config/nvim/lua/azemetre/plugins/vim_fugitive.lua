return {
	-- #vim-motions #ui #git #keyboard
	-- fugitive - git workflow
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>G", ":Git<CR>", desc = "Git Status" },
			{ "<leader>Gb", ":Git blame<CR>", desc = "Git Blame" },
			{ "<leader>Gp", ":Git push<CR>", desc = "Git Push" },
		},
	},
}

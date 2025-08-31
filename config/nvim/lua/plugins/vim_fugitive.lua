-- #vim #tpope #vim-motions #ui #git #keyboard
-- fugitive - git workflow
---@type Utils.Pack.Spec
return {
	src = "https://github.com/tpope/vim-fugitive",
	defer = true,
	config = function()
		vim.keymap.set("n", "<leader>G", ":Git<CR>", { desc = "Git Status" })
		vim.keymap.set(
			"n",
			"<leader>Gb",
			":Git blame<CR>",
			{ desc = "Git Blame" }
		)
		vim.keymap.set("n", "<leader>Gp", ":Git push<CR>", { desc = "Git Push" })
	end,
}

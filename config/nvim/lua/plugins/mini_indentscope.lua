-- #ui #code #text
-- active indent guide and indent text objects
---@type Utils.Pack.Spec
return {
	src = "https://github.com/nvim-mini/mini.indentscope",
	defer = true,
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})

		require("mini.indentscope").setup({
			symbol = "│",
			options = { try_as_border = true },
		})
	end,
}

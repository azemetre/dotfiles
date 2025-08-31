-- #ui #editor #lsp
---@type Utils.Pack.Spec
return {
	src = "https://github.com/j-hui/fidget.nvim",
	defer = true,
	config = function()
		require("fidget").setup({})
	end,
}

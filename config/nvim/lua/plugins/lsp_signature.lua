-- #lsp #editor #ux #ui
---@type Utils.Pack.Spec
return {
	src = "https://github.com/ray-x/lsp_signature.nvim",
	defer = true,
	config = function()
		require("lsp_signature").setup({
			always_trigger = true,
			hint_enable = false,
		})
	end,
}

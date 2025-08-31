-- #color #css #ui
-- color highlighter
---@type Utils.Pack.Spec
return {
	src = "https://github.com/brenoprata10/nvim-highlight-colors",
	defer = true,
	config = function()
		require("nvim-highlight-colors").setup({
			render = "background",
			enable_named_colors = true,
			enable_tailwind = true,
		})
	end,
}

-- In your package manager config (lazy.nvim)
---@type Utils.Pack.Spec
return {
	src = "https://github.com/L3MON4D3/LuaSnip",
	defer = true,
	dependencies = {
		-- TS/JS
		{ defer = true, src = "https://github.com/rafamadriz/friendly-snippets" },
		config = function()
			local ls = require("luasnip")
			-- Load friendly-snippets (VSCode style snippets)
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}

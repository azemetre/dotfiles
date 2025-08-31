-- #core #plugin
---@type Utils.Pack.Spec
return {
	src = "https://github.com/folke/lazydev.nvim",
	defer = true,
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "lua",
			once = true,
			callback = function()
				require("lazydev").setup({
					library = {},
					enabled = function(root_dir)
						return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
					end,
				})
			end,
		})
	end,
}

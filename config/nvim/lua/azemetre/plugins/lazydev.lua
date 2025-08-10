-- #core #plugin
return {
	"folke/lazydev.nvim",
	ft = "lua", -- only load on lua files
	opts = {
		library = {
			-- Or relative, which means they will be resolved from the plugin dir.
			"lazy.nvim",
			-- Only load the lazyvim library when the `Azemetre` global is found
			{ path = "Azemetre", words = { "Azemetre" } },
		},
		-- disable when a .luarc.json file is found
		enabled = function(root_dir)
			return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
		end,
	},
}

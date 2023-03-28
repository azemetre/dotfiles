local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
	spec = { import = config_namespace .. ".plugins" },
	dev = {
		path = "~/.config/nvim",
		patterns = { "azemetre" },
	},
	checker = {
		enabled = true,
		notify = false,
		frequency = 900,
	},
	change_detection = {
		enabled = true,
		notify = false,
	},
	ui = {
		icons = {
			plugin = "",
		},
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				-- "matchit", -- TODO: definitely use this I think, may need to tweak
				"matchparen",
				-- "netrwPlugin", -- TODO: definitely use this I think, may need to tweak
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

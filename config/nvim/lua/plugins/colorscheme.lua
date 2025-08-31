-- #colorscheme #theme #color
-- for housing multiple color schemes
---@type Utils.Pack.Spec[]
return {
	src = "https://github.com/folke/tokyonight.nvim",
	name = "tokyonight",
	config = function()
		local tokyonight = require("tokyonight")
		tokyonight.setup({ style = "storm" })
		tokyonight.load()
	end,

	-- # Create symlink in start/ - plugin loads automatically
	-- ln -s ~/github/shimman-eekah.nvim ~/.local/share/nvim/site/pack/develop/start/shimman-eekah
	--
	-- # Create symlink in opt/ - requires vim.cmd.packadd('shimman-eekah')
	-- ln -s ~/github/shimman-eekah.nvim ~/.local/share/nvim/site/pack/develop/opt/shimman-eekah
	--
	-- # Remove from start/
	-- rm ~/.local/share/nvim/site/pack/develop/start/shimman-eekah
	--
	-- # OR remove from opt/
	-- rm ~/.local/share/nvim/site/pack/develop/opt/shimman-eekah
}

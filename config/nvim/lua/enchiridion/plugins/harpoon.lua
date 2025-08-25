-- #ui #editor #vim-motion #keyboard #core
-- jump between 4 files
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		local harpoon_extensions = require("harpoon.extensions")
		harpoon:setup()
		harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
	end,
	keys = {
		{
			"<C-e>",
			function()
				require("harpoon"):list():add()
			end,
			desc = "add file to harpoon",
		},
		{
			"<C-t>",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "toggle harpoon menu",
		},
		{
			"<C-h>",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "navigate to harpoon file 1",
		},
		{
			"<C-j>",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "Navigate to harpoon file 2",
		},
		{
			"<C-k>",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "navigate to harpoon file 3",
		},
		{
			"<C-l>",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "navigate to harpoon file 4",
		},
		{
			"<C-S-P>",
			function()
				require("harpoon"):list():prev()
			end,
			desc = "previous harpoon file",
		},
		{
			"<C-S-N>",
			function()
				require("harpoon"):list():next()
			end,
			desc = "next harpoon file",
		},
	},
}

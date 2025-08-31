-- #ui #editor #vim-motion #keyboard #core
-- jump between 4 files
---@type Utils.Pack.Spec
return {
	src = "https://github.com/ThePrimeagen/harpoon",
	defer = true,
	version = "harpoon2",
	dependencies = {
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
	},
	config = function()
		local harpoon = require("harpoon")
		local harpoon_extensions = require("harpoon.extensions")
		harpoon:setup()
		harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

		vim.keymap.set("n", "<C-e>", function()
			require("harpoon"):list():add()
		end, { desc = "add file to harpoon" })

		vim.keymap.set("n", "<C-t>", function()
			local h = require("harpoon")
			h.ui:toggle_quick_menu(h:list())
		end, { desc = "toggle harpoon menu" })

		vim.keymap.set("n", "<C-h>", function()
			require("harpoon"):list():select(1)
		end, { desc = "navigate to harpoon file 1" })

		vim.keymap.set("n", "<C-j>", function()
			require("harpoon"):list():select(2)
		end, { desc = "Navigate to harpoon file 2" })

		vim.keymap.set("n", "<C-k>", function()
			require("harpoon"):list():select(3)
		end, { desc = "navigate to harpoon file 3" })

		vim.keymap.set("n", "<C-l>", function()
			require("harpoon"):list():select(4)
		end, { desc = "navigate to harpoon file 4" })

		vim.keymap.set("n", "<C-S-P>", function()
			require("harpoon"):list():prev()
		end, { desc = "previous harpoon file" })

		vim.keymap.set("n", "<C-S-N>", function()
			require("harpoon"):list():next()
		end, { desc = "next harpoon file" })
	end,
}

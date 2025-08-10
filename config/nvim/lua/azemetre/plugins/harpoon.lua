return {
	-- jump between 4 files
	{
		"ThePrimeagen/harpoon",
		dependencies = "nvim-lua/plenary.nvim",
		keys = {
			{ "<C-e>", ":lua require('harpoon.mark').add_file()<CR>" },
			{ "<C-t>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>" },
			{ "<C-h>", ":lua require('harpoon.ui').nav_file(1)<CR>" },
			{ "<C-j>", ":lua require('harpoon.ui').nav_file(2)<CR>" },
			{ "<C-k>", ":lua require('harpoon.ui').nav_file(3)<CR>" },
			{ "<C-l>", ":lua require('harpoon.ui').nav_file(4)<CR>" },
		},
	},
}

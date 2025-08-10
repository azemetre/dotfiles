-- #directory #editor #ui #keyboard #vim-motion
-- create, move, delete files as buffers
return {
	"stevearc/oil.nvim",
	event = "VeryLazy",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		-- adds oil buffer to jumplist
		cleanup_delay_ms = false,
		columns = {
			"icon",
			-- "permissions",
			"size",
			"mtime",
		},
		-- Configuration for the floating window in oil.open_float
		float = {
			padding = 2,
			max_width = 75,
			min_width = 40,
			max_height = 40,
			-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
			-- min_height = 25,
			-- optionally define an integer/float for the exact height of the preview window
			-- height = nil,
			border = "rounded",
		},
	},
	-- Optional dependencies
	dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
}

-- #directory #editor #ui #keyboard #vim-motion
-- create, move, delete files as buffers
---@type Utils.Pack.Spec
return {
	src = "https://github.com/stevearc/oil.nvim",
	defer = true,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/nvim-tree/nvim-web-devicons",
		},
	},
	---@module 'oil'
	---@type oil.SetupOpts
	config = function()
		local hidden_files = {
			".DS_Store",
			"Thumbs.db",
		}

		require("oil").setup({
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
			view_options = {
				show_hidden = true,
				is_hidden_file = function(name, bufnr)
					for _, hidden in ipairs(hidden_files) do
						if name == hidden then
							return true
						end
					end
					return false
				end,
			},
			vim.keymap.set(
				"n",
				"<leader>-",
				"<CMD>Oil --float<CR>",
				{ desc = "Open parent directory" }
			),
		})
	end,
}

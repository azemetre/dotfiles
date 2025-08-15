-- #editor #keyboard
-- surround
return {
	"echasnovski/mini.surround",
	keys = { "gz" },
	opts = {
		mappings = {
			add = "gza", -- Add surrounding in Normal and Visual modes
			delete = "gzd", -- Delete surrounding
			find = "gzf", -- Find surrounding (to the right)
			find_left = "gzF", -- Find surrounding (to the left)
			highlight = "gzh", -- Highlight surrounding
			replace = "gzr", -- Replace surrounding
			update_n_lines = "gzn", -- Update `n_lines`
		},
	},
	config = function(_, opts)
		-- use gs mappings instead of s to prevent conflict with leap
		require("mini.surround").setup(opts)
	end,
}

local icons = require("enchiridion.theme").icons

-- #ui #ux #editor
-- file explorer
return {
	"nvim-tree/nvim-tree.lua",
	event = "VeryLazy",
	cmd = "NvimTree",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<leader>et",
			"<cmd>NvimTreeToggle<CR>",
			desc = "NvimTree toggle",
		},
		{ "<leader>ef", "<cmd>NvimTreeFocus<CR>", desc = "NvimTree focus" },
		{
			"<leader>er",
			"<cmd>NvimTreeRefresh<CR>",
			desc = "NvimTree refresh",
		},
	},
	opts = {
		disable_netrw = false,
		hijack_netrw = true,
		diagnostics = {
			enable = false,
			icons = {
				hint = icons.hint,
				info = icons.info,
				warning = icons.warning,
				error = icons.error,
			},
		},
		renderer = {
			add_trailing = false,
			group_empty = true,
			highlight_git = true,
			highlight_opened_files = "all",
			indent_markers = {
				enable = true,
			},
			icons = {
				glyphs = {
					default = icons.file,
					symlink = icons.symlink,
					git = {
						unstaged = icons.unmerged,
						staged = icons.staged,
						unmerged = icons.unmerged,
						renamed = icons.renamed,
						untracked = icons.untracked,
						deleted = icons.deleted,
						ignored = icons.ignored,
					},
					folder = {
						arrow_open = icons.arrow_open,
						arrow_closed = icons.arrow_closed,
						default = icons.default,
						open = icons.open,
						empty = icons.empty,
						empty_open = icons.empty_open,
						symlink = icons.symlink,
						symlink_open = icons.symlink_open,
					},
				},
			},
		},
		update_focused_file = {
			enable = true,
			update_cwd = false,
		},
		git = {
			enable = true,
			ignore = false,
		},
		view = {
			width = 40,
			side = "right",
			relativenumber = true,
		},
	},
}

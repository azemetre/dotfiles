-- #ui #ux #editor
-- file explorer
---@type Utils.Pack.Spec
return {
	src = "https://github.com/nvim-tree/nvim-tree.lua",
	dependencies = {
		{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	},
	config = function()
		local icons = require("utils.theme").icons

		require("nvim-tree").setup({
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
		})

		vim.keymap.set(
			"n",
			"<leader>et",
			"<cmd>NvimTreeToggle<CR>",
			{ desc = "NvimTree toggle" }
		)
		vim.keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFocus<CR>",
			{ desc = "NvimTree focus" }
		)
		vim.keymap.set(
			"n",
			"<leader>er",
			"<cmd>NvimTreeRefresh<CR>",
			{ desc = "NvimTree refresh" }
		)
	end,
}

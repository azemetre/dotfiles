local icons = require("azemetre.theme").icons

return {
	-- file explorer
	{ "echasnovski/mini.files", version = "*" },

	-- file explorer
	{
		"nvim-tree/nvim-tree.lua",
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
	},

	-- search/replace in multiple files
	{
		"windwp/nvim-spectre",
        -- stylua: ignore
        keys = {
            { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
        },
	},

	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
		},
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>" },
			{ "<leader>fo", "<cmd>Telescope oldfiles<cr>" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>" },
		},
		config = function()
			local always_ignore_these = {
				"yarn.lock", -- nodejs
				"package%-lock.json", -- nodejs
				"node_modules/.*", -- nodejs
				"vendor/*", -- golang
				"%.git/.*",
				"%.png",
				"%.jpeg",
				"%.jpg",
				"%.ico",
				"%.webp",
				"%.avif",
				"%.heic",
				"%.mp3",
				"%.mp4",
				"%.mkv",
				"%.mov",
				"%.wav",
				"%.flv",
				"%.avi",
				"%.webm",
				"%.db",
			}

			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							-- don't go into normal mode, just close
							["<Esc>"] = require("telescope.actions").close,
							-- scroll the list with <c-j> and <c-k>
							["<C-j>"] = require("telescope.actions").move_selection_next,
							["<C-k>"] = require("telescope.actions").move_selection_previous,
							-- move the preview window up and down
							["<C-u>"] = require("telescope.actions").preview_scrolling_up,
							["<C-d>"] = require("telescope.actions").preview_scrolling_down,
						},
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--trim",
					},
					layout_strategy = "vertical",
					layout_config = {
						prompt_position = "top",
						horizontal = {
							mirror = true,
							preview_cutoff = 100,
							preview_width = 0.5,
						},
						vertical = {
							mirror = true,
							preview_cutoff = 0.4,
						},
						flex = {
							flip_columns = 110,
						},
						height = 0.94,
						width = 0.86,
					},
					prompt_prefix = "   ",
					selection_caret = "  ",
					entry_prefix = "  ",
					initial_mode = "insert",
					selection_strategy = "reset",
					sorting_strategy = "ascending",
					file_sorter = require("telescope.sorters").get_fuzzy_file,
					file_ignore_patterns = always_ignore_these,
					generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
					path_display = { "truncate" },
					winblend = 0,
					border = {},
					borderchars = {
						"─",
						"│",
						"─",
						"│",
						"╭",
						"╮",
						"╯",
						"╰",
					},
					color_devicons = true,
					use_less = true,
					set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
					-- Developer configurations: Not meant for general override
					buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
				},
				pickers = {
					find_files = {
						find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
						hidden = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
		end,
	},

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

	-- references
	{
		"RRethy/vim-illuminate",
		event = "BufReadPost",
		opts = { delay = 200 },
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
        -- stylua: ignore
        keys = {
            { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
            { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
        },
	},

	{
		"rmagatti/goto-preview",
		opts = {
			-- Width of the floating window
			width = 120,
			-- Height of the floating window
			height = 15,
			-- Border characters of the floating window
			border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
			-- Bind default mappings
			default_mappings = false,
			-- Print debug information
			debug = false,
			-- 0-100 opacity level of the floating window where 100 is fully transparent.
			opacity = nil,
			-- Binds arrow keys to resizing the floating window.
			resizing_mappings = false,
			-- A function taking two arguments, a buffer and a window to be ran as a hook.
			post_open_hook = nil,
			-- Focus the floating window when opening it.
			focus_on_open = true,
			-- Dismiss the floating window when moving the cursor.
			dismiss_on_move = false,
			-- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
			force_close = true,
			-- the bufhidden option to set on the floating window. See :h bufhidden
			bufhidden = "wipe",
		},
	},

	-- editorconfig
	{
		"editorconfig/editorconfig-vim",
		event = "BufReadPre",
	},

	-- buffer remove
	{
		"echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
            { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
        },
	},

	-- move any selection, in any directiond
	{
		"echasnovski/mini.move",
	},

	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{
				"<leader>xx",
				"<cmd>TroubleToggle document_diagnostics<cr>",
				desc = "Document Diagnostics (Trouble)",
			},
			{
				"<leader>xw",
				"<cmd>TroubleToggle workspace_diagnostics<cr>",
				desc = "Workspace Diagnostics (Trouble)",
			},
		},
	},

	-- todo comments
	-- PERF:
	-- HACK:
	-- TODO:
	-- FIX:
	-- NOTE:
	-- WARNING:
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = "BufReadPost",
		opts = {
			keywords = {
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			},
		},
		config = true,
        -- stylua: ignore
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
            { "<leader>xtt", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo Trouble" },
            { "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
        },
	},

	-- sleuth
	-- adjusts tabs and shiftwidth
	{
		"tpope/vim-sleuth",
	},
}

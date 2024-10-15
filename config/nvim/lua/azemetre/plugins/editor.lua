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
			{ "<leader>fx", "<cmd>Telescope lsp_document_symbols<cr>" },
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
			{ "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
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
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Document Diagnostics (Trouble)",
			},
			{
				"<leader>xq",
				"<cmd>Trouble quickfix toggle<cr>",
				desc = "Quickfix (Trouble)",
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
			{ "]t",          function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
			{ "[t",          function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
			{ "<leader>xt",  "<cmd>TodoTrouble<cr>",                              desc = "Todo Trouble" },
			{ "<leader>xtt", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo Trouble" },
			{ "<leader>xT",  "<cmd>TodoTelescope<cr>",                            desc = "Todo Telescope" },
		},
	},

	-- create, move, delete files as buffers
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			columns = {
				"icon",
				-- "permissions",
				"size",
				"mtime",
			},
			-- Configuration for the floating window in oil.open_float
			float = {
				padding = 2,
				max_width = 60,
				min_width = 40,
				max_height = 40,
				-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
				-- min_height = 25,
				-- optionally define an integer/float for the exact height of the preview window
				-- height = nil,
				border = "rounded",
			},
			cleanup_delay_ms = false,
		},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
	},

	-- folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
			"neovim/nvim-lspconfig",
		},
		event = "BufReadPost",
		opts = {
			provider_selector = function(bufnr, filetype, buftype)
				return { "lsp", "indent" }
			end,
			fold_virt_text_handler = function(
				virtText,
				lnum,
				endLnum,
				width,
				truncate
			)
				local newVirtText = {}
				local suffix = ("\t⤵ %d lines folded ⤵"):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix
								.. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end,
		},
		config = function(_, opts)
			-- Fold options
			vim.o.foldcolumn = "0"
			vim.o.foldlevel = 99 -- Using ufo provider need a large value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			require("ufo").setup(opts)
		end,
	},

	-- sleuth
	-- adjusts tabs and shiftwidth
	{
		"tpope/vim-sleuth",
	},
}

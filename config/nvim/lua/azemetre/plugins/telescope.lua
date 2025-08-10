return {
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
}

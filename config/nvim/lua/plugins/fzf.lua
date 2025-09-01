-- #telescope #picker #ui #vim-motion #keyboard #core
-- fzf-lua fuzzy finder
---@type Utils.Pack.Spec
return {
	src = "https://github.com/ibhagwan/fzf-lua",
	defer = true,
	dependencies = {
		{
			defer = true,
			src = "https://github.com/nvim-tree/nvim-web-devicons",
		},
	},
	config = function()
		local fzf = require("fzf-lua")

		local always_ignore_these = {
			".git/",
			"node_modules/",
			"package-lock.json",
			"vendor/",
			"yarn.lock",
			"*.avi",
			"*.avif",
			"*.db",
			"*.flv",
			"*.gif",
			"*.heic",
			"*.ico",
			"*.jpeg",
			"*.jpg",
			"*.mp3",
			"*.mp4",
			"*.mkv",
			"*.mov",
			"*.png",
			"*.wav",
			"*.webm",
			"*.webp",
		}

		local fd_excludes = ""
		local rg_globs = ""

		for _, pattern in ipairs(always_ignore_these) do
			fd_excludes = fd_excludes .. " --exclude '" .. pattern .. "'"
			rg_globs = rg_globs .. " -g '!" .. pattern .. "'"
		end

		fzf.setup({
			-- Global configuration
			fzf_opts = { ["--cycle"] = "" },
			winopts = {
				backdrop = false,
				height = 0.94,
				width = 0.86,
				row = 0.5,
				col = 0.5,
				border = {
					"╭",
					"─",
					"╮",
					"│",
					"╯",
					"─",
					"╰",
					"│",
				},
				-- Preview window configuration
				preview = {
					layout = "vertical",
					vertical = "down:60%",
					bat = {
						cmd = "bat",
						args = "--color=always --style=numbers,changes",
						theme = "ansi",
					},
				},
			},

			keymap = {
				builtin = {
					["<Esc>"] = "hide",
					["<C-j>"] = "down",
					["<C-k>"] = "up",
					["<C-u>"] = "preview-page-up",
					["<C-d>"] = "preview-page-down",
				},
				fzf = {
					["ctrl-j"] = "down",
					["ctrl-k"] = "up",
					["ctrl-u"] = "preview-page-up",
					["ctrl-d"] = "preview-page-down",
				},
			},

			grep = {
				rg_opts = "--color=never --no-heading --with-filename --line-number --column --smart-case --trim"
					.. rg_globs,
				rg_glob = true,
			},

			files = {
				cmd = "fd --type f --strip-cwd-prefix --hidden --follow"
					.. fd_excludes,
			},

			lsp = {
				symbols = {
					symbol_style = 1,
				},
			},

			git = {
				commits = {
					cmd = "git log --color=never --pretty=format:'%C(yellow)%h%C(reset) %C(cyan)%ad%C(reset) %C(green)%an%C(reset) %s' --date=short",
					preview = "git show --color=always {1}",
				},
				bcommits = {
					cmd = "git log --color=never --pretty=format:'%C(yellow)%h%C(reset) %C(cyan)%ad%C(reset) %C(green)%an%C(reset) %s' --date=short",
					preview = "git show --color=always {1}",
				},
				branches = {
					cmd = "git branch --all --color=never",
					preview = "git log --oneline --graph --date=short --color=always --pretty='format:%C(auto)%cd %h%d %s' $(sed s/^..// <<< {} | cut -d' ' -f1)",
				},
				status = {
					cmd = "git status --porcelain=v1",
					preview = "git diff --color=always {-1}",
				},
			},

			-- Buffers configuration
			buffers = {
				sort_lastused = true,
			},

			-- Help tags
			helptags = {
				-- Preview help content
				preview = "help {1} | head -50",
			},

			-- Default options for all pickers
			defaults = {
				-- Prompt styling
				prompt = "❯ ",
				git_icons = true,
				file_icons = true,
				color_icons = true,
			},
		})

		fzf.register_ui_select()

		vim.keymap.set(
			"n",
			"<leader>ff",
			"<cmd>FzfLua files<cr>",
			{ desc = "Telescope Files" }
		)
		vim.keymap.set(
			"n",
			"<leader>fg",
			"<cmd>FzfLua live_grep<cr>",
			{ desc = "Telescope Grep" }
		)
		vim.keymap.set(
			"n",
			"<leader>fc",
			"<cmd>FzfLua highlights<cr>",
			{ desc = "Telescope highlights" }
		)
		vim.keymap.set(
			"n",
			"<leader>fb",
			"<cmd>FzfLua buffers<cr>",
			{ desc = "Telescope Buffers" }
		)
		vim.keymap.set(
			"n",
			"<leader>fk",
			"<cmd>FzfLua keymaps<cr>",
			{ desc = "Telescope keymaps" }
		)
		vim.keymap.set(
			"n",
			"<leader>fx",
			"<cmd>FzfLua lsp_document_symbols<cr>",
			{ desc = "Telescope Document Symbols" }
		)
		vim.keymap.set(
			"n",
			"<leader>fh",
			"<cmd>FzfLua help_tags<cr>",
			{ desc = "Telescope Help Tags" }
		)
		vim.keymap.set(
			"n",
			"<leader>fG",
			"<cmd>FzfLua git_commits<cr>",
			{ desc = "Telescope Git Commits" }
		)
		vim.keymap.set(
			"n",
			"<leader>fB",
			"<cmd>FzfLua git_branches<cr>",
			{ desc = "Telescope Git Branches" }
		)
	end,
}

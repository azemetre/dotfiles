-- #telescope #picker #ui #vim-motion #keyboard #core
-- fzf-lua fuzzy finder
return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	cmd = "FzfLua",
	keys = {
		{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Telescope Files" },
		{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Telescope Grep" },
		{
			"<leader>fc",
			"<cmd>FzfLua highlights<cr>",
			desc = "Telescope highlights",
		},
		{
			"<leader>fb",
			"<cmd>FzfLua buffers<cr>",
			desc = "Telescope Buffers",
		},
		{
			"<leader>fk",
			"<cmd>FzfLua keymaps<cr>",
			desc = "Telescope keymaps",
		},
		{
			"<leader>fx",
			"<cmd>FzfLua lsp_document_symbols<cr>",
			desc = "Telescope Document Symbols",
		},
		{
			"<leader>fh",
			"<cmd>FzfLua help_tags<cr>",
			desc = "Telescope Help Tags",
		},

		-- Git integration shortcuts
		{
			"<leader>fG",
			"<cmd>FzfLua git_commits<cr>",
			desc = "Telescope Git Commits",
		},
		{
			"<leader>fB",
			"<cmd>FzfLua git_branches<cr>",
			desc = "Telescope Git Branches",
		},
	},
	config = function()
		local fzf = require("fzf-lua")

		local always_ignore_these = {
			"yarn.lock",
			"package-lock.json",
			"node_modules/",
			"vendor/",
			".git/",
			"*.png",
			"*.jpeg",
			"*.jpg",
			"*.ico",
			"*.webp",
			"*.avif",
			"*.heic",
			"*.mp3",
			"*.mp4",
			"*.mkv",
			"*.mov",
			"*.wav",
			"*.flv",
			"*.avi",
			"*.webm",
			"*.db",
		}

		fzf.setup({
			-- Global configuration
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
				rg_opts = "--color=never --no-heading --with-filename --line-number --column --smart-case --trim",
				rg_glob = true,
				-- Add file ignore patterns
				-- Note: fzf-lua handles this through fd/rg directly
			},

			files = {
				cmd = "fd --type f --strip-cwd-prefix --hidden",
				-- File ignore patterns are handled by fd's .gitignore and .fdignore
				find_opts = [[-type f -not -path '*/\.git/*' -not -path '*/node_modules/*' -not -path '*/vendor/*']],
				rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!node_modules' -g '!vendor'",
				fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude vendor",
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
	end,
}

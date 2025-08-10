return {
	{
		"saghen/blink.nvim",
		lazy = false, -- lazy loading handled internally
		build = "cargo build --release", -- for delimiters
		keys = {
			-- chartoggle
			{
				"<C-;>",
				function()
					require("blink.chartoggle").toggle_char_eol(";")
				end,
				mode = { "n", "v" },
				desc = "Toggle ; at eol",
			},
			{
				",",
				function()
					require("blink.chartoggle").toggle_char_eol(",")
				end,
				mode = { "n", "v" },
				desc = "Toggle , at eol",
			},

			-- tree
			{
				"<C-e>",
				"<cmd>BlinkTree reveal<cr>",
				desc = "Reveal current file in tree",
			},
			{
				"<leader>E",
				"<cmd>BlinkTree toggle<cr>",
				desc = "Reveal current file in tree",
			},
			{
				"<leader>e",
				"<cmd>BlinkTree toggle-focus<cr>",
				desc = "Toggle file tree focus",
			},
		},
		opts = {
			chartoggle = { enabled = true },
			tree = { enabled = true },
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- see the "default configuration" section below for full documentation on how to define
			-- your own keymap.
			keymap = { preset = "super-tab" },
			-- completion = {
			--   menu = { auto_show = function(ctx) return ctx.mode ~= 'cmdline' end }
			-- },
			completion = {
				menu = {
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
					},
				},
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
			},
			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release
				use_nvim_cmp_as_default = false,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},
			snippets = {
				expand = function(snippet)
					require("luasnip").lsp_expand(snippet)
				end,
				active = function(filter)
					if filter and filter.direction then
						return require("luasnip").jumpable(filter.direction)
					end
					return require("luasnip").in_snippet()
				end,
				jump = function(direction)
					require("luasnip").jump(direction)
				end,
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			-- experimental signature help support
			signature = { enabled = true },
		},
	},
}

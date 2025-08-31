-- #cmp #lsp #core #keyboard
---@type utils.pack.spec
return {
	src = "https://github.com/saghen/blink.cmp",
	defer = true,
	version = vim.version.range("*"),
	-- optional: provides snippets for the snippet source
	dependencies = {
		{ src = "https://github.com/l3mon4d3/luasnip", version = "v2.4.0" },
	},
	data = { build = "cargo build --release" },
	config = function()
		-- Check if the binary needs building/rebuilding
		local plugin_path = vim.fn.stdpath("data")
			.. "/site/pack/core/opt/blink.cmp"
		local lib_path = plugin_path .. "/target/release/libblink_cmp_fuzzy.dylib"

		-- Build if missing or wrong architecture
		if vim.fn.filereadable(lib_path) == 0 then
			vim.notify("Building blink.cmp fuzzy module...")
			vim.fn.system("cd " .. plugin_path .. " && cargo build --release")
		end

		local blink = require("blink.cmp")

		---@module 'blink.cmp'
		---@type blink.cmp.config
		blink.setup({
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- 'none' disables mappings have to provide your own
			-- see the "default configuration" section below for full documentation on how to define
			-- your own keymap.
			keymap = {
				preset = "none",
				-- navigation
				["<c-p>"] = { "select_prev", "fallback" },
				["<c-n>"] = { "select_next", "fallback" },
				["<c-k>"] = { "select_prev", "fallback" },
				["<c-j>"] = { "select_next", "fallback" },

				-- selection
				["<cr>"] = { "accept", "fallback" },
				["<c-y>"] = { "accept", "fallback" },
				["<esc>"] = { "cancel", "fallback" },
				["<c-e>"] = { "cancel", "fallback" },
				["<c-x>"] = { "cancel", "fallback" },

				-- snippet navigation
				["<tab>"] = { "snippet_forward", "select_next", "fallback" },
				["<s-tab>"] = { "snippet_backward", "select_prev", "fallback" },

				-- documentation
				["<c-d>"] = { "scroll_documentation_down", "fallback" },
				["<c-u>"] = { "scroll_documentation_up", "fallback" },

				-- show completion menu
				["<c-q>"] = { "show", "fallback" },
				["<c-space>"] = { "show", "fallback" },
				["<c-o>"] = { "show", "fallback" },
				["<c-h>"] = { "show", "fallback" },
			},
			cmdline = {
				keymap = {
					preset = "none",
					-- navigation
					["<c-p>"] = { "select_prev", "fallback" },
					["<c-n>"] = { "select_next", "fallback" },
					["<c-k>"] = { "select_prev", "fallback" },
					["<c-j>"] = { "select_next", "fallback" },
					-- selection
					["<c-y>"] = { "accept", "fallback" },
					["<esc>"] = { "cancel", "fallback" },
					["<c-e>"] = { "cancel", "fallback" },
					["<c-x>"] = { "cancel", "fallback" },
				},
				completion = { menu = { auto_show = true } },
			},
			completion = {
				menu = {
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
						},
					},
					-- completion window styling
					border = "rounded", -- options: "none", "single", "double", "rounded", "solid", "shadow"
					winblend = 0, -- transparency (0-100)
					winhighlight = "normal:blinkcmpmenu,floatborder:blinkcmpmenuborder,cursorline:blinkcmpmenuselection,search:none",
					-- window size
					max_height = 20,
					min_width = 15,
					-- scrollbar
					scrollbar = true,
				},

				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
					-- documentation window styling
					window = {
						border = "rounded", -- same border options as menu
						winblend = 0,
						winhighlight = "normal:blinkcmpdoc,floatborder:blinkcmpdocborder",
						max_width = 80,
						max_height = 20,
						-- position relative to completion menu
						direction_priority = {
							menu_north = { "e", "w", "n", "s" },
							menu_south = { "e", "w", "s", "n" },
						},
					},
				},

				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
			},

			appearance = {
				use_nvim_cmp_as_default = false,
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
				providers = {
					buffer = {
						-- reduce buffer completions
						max_items = 5, -- limit number of buffer suggestions
						min_keyword_length = 3, -- only show after 3 characters
						score_offset = -10, -- lower priority than other sources
					},
				},
			},

			-- experimental signature help support
			signature = {
				enabled = true,
				window = {
					border = "rounded",
					winblend = 0,
					winhighlight = "normal:blinkcmpsignaturehelp,floatborder:blinkcmpsignaturehelpborder",
					max_width = 80,
					max_height = 10,
				},
			},
		})
	end,
}

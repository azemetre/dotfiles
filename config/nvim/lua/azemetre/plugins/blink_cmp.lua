-- #cmp #lsp #core #keyboard
return {
	"saghen/blink.cmp",
	lazy = false, -- lazy loading handled internally
	-- optional: provides snippets for the snippet source
	dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },

	-- use a release tag to download pre-built binaries
	version = "*",
	build = "cargo build --release",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
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
			["<C-u>"] = { "scroll_documentation_up", "fallback" },

			-- show completion menu
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
						{ "kind_icon", "kind" },
					},
				},
				-- Completion window styling
				border = "rounded", -- Options: "none", "single", "double", "rounded", "solid", "shadow"
				winblend = 0, -- Transparency (0-100)
				winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				-- Window size
				max_height = 20,
				min_width = 15,
				-- Scrollbar
				scrollbar = true,
			},

			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				-- Documentation window styling
				window = {
					border = "rounded", -- Same border options as menu
					winblend = 0,
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
					max_width = 80,
					max_height = 20,
					-- Position relative to completion menu
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
			nerd_font_variant = "hack",
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
					-- Reduce buffer completions
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
				winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
				max_width = 80,
				max_height = 10,
			},
		},
	},
	-- allows extending the providers array elsewhere in your config
	-- without having to redefine it
	-- opts_extend = { "sources.default" }
}

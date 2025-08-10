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
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },

			-- selection
			["<CR>"] = { "select_accept_and_enter", "fallback" },
			["<C-c>"] = { "accept", "fallback" },
			["<C-y>"] = { "accept", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },

			-- snippet navigation
			["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },

			-- documentation
			["<C-d>"] = { "scroll_documentation_down", "fallback" },
			["<C-u>"] = { "scroll_documentation_up", "fallback" },

			-- show completion menu
			["<C-space>"] = { "show", "fallback" },
		},
		cmdline = {
			keymap = {
				preset = "none", -- disable cmdline keymaps to avoid conflicts
			},
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
		signature = { enabled = true },
	},
	-- allows extending the providers array elsewhere in your config
	-- without having to redefine it
	-- opts_extend = { "sources.default" }
}

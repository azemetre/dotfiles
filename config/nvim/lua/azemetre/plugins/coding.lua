return {

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	       -- stylua: ignore
	       keys = {
				  {
	               "<tab>",
	               function()
	                   return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
	               end,
	               expr = true, remap = true, silent = true, mode = "i",
	           },
	           { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
	           { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
	       },
	},

	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- Or relative, which means they will be resolved from the plugin dir.
				"lazy.nvim",
				-- Only load the lazyvim library when the `LazyVim` global is found
				{ path = "Azemetre", words = { "Azemetre" } },
			},
			-- disable when a .luarc.json file is found
			enabled = function(root_dir)
				return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
			end,
		},
	},

	-- auto completion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			{
				"zbirenbaum/copilot-cmp",
				config = true,
				dependencies = {
					{ "zbirenbaum/copilot.lua", config = true },
				},
			},
			"zbirenbaum/copilot.lua",
		},
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-j>"] = cmp.mapping.select_next_item({
						behavior = cmp.SelectBehavior.Insert,
					}),
					["<C-k>"] = cmp.mapping.select_prev_item({
						behavior = cmp.SelectBehavior.Insert,
					}),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					-- Accept currently selected item. Set `select` to `false`
					-- to only confirm explicitly selected items.
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "copilot", priority = 1001 },
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "path", priority = 500 },
					{ name = "buffer", priority = 250 },
				}),
				formatting = {
					format = function(_, item)
						local icons = Azemetre.config.icons.kinds
						if icons[item.kind] then
							item.kind = icons[item.kind] .. item.kind
						end
						return item
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				experimental = {
					ghost_text = {
						hl_group = "LspCodeLens",
					},
				},
			}
		end,
	},

	-- auto pairs
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},

	-- surround
	{
		"echasnovski/mini.surround",
		keys = { "gz" },
		opts = {
			mappings = {
				add = "gza", -- Add surrounding in Normal and Visual modes
				delete = "gzd", -- Delete surrounding
				find = "gzf", -- Find surrounding (to the right)
				find_left = "gzF", -- Find surrounding (to the left)
				highlight = "gzh", -- Highlight surrounding
				replace = "gzr", -- Replace surrounding
				update_n_lines = "gzn", -- Update `n_lines`
			},
		},
		config = function(_, opts)
			-- use gs mappings instead of s to prevent conflict with leap
			require("mini.surround").setup(opts)
		end,
	},

	-- comments
	-- {
	-- 	"JoosepAlviste/nvim-ts-context-commentstring",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		enable_autocmd = false,
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("ts_context_commentstring").setup(opts)
	-- 	end,
	-- },
	-- {
	-- 	"echasnovski/mini.comment",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		custom_commentstring = function()
	-- 			return require("ts_context_commentstring").calculate_commentstring()
	-- 				or vim.bo.commentstring
	-- 		end,
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("mini.comment").setup(opts)
	-- 	end,
	-- },

	-- better text-objects
	{
		"echasnovski/mini.ai",
		keys = {
			{ "a", mode = { "x", "o" } },
			{ "i", mode = { "x", "o" } },
		},
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- no need to load the plugin, since we only need its queries
					require("lazy.core.loader").disable_rtp_plugin(
						"nvim-treesitter-textobjects"
					)
				end,
			},
		},
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter(
						{ a = "@function.outer", i = "@function.inner" },
						{}
					),
					c = ai.gen_spec.treesitter(
						{ a = "@class.outer", i = "@class.inner" },
						{}
					),
				},
			}
		end,
		config = function(_, opts)
			local ai = require("mini.ai")
			ai.setup(opts)
		end,
	},

	-- copilot
	-- { "github/copilot.vim" },
}

return {

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

	-- `vim.uv` typings
	{ "Bilal2453/luvit-meta", lazy = true },

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

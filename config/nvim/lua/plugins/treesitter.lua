-- #language #core #lsp #syntax-highlight
---@type Utils.Pack.Spec
return {
	src = "https://github.com/nvim-treesitter/nvim-treesitter",
	defer = true,
	---@type TSConfig
	config = function()
		local ensure_installed = {
			"bash",
			"cmake",
			"css",
			"dockerfile",
			"go",
			"gomod",
			"html",
			"javascript",
			-- "jsdoc",
			"json",
			"json5",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"python",
			"rust",
			"scss",
			"toml",
			"typescript",
			"tsx",
			"vim",
			"zig",
		}

		require("nvim-treesitter.configs").setup({
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
			context_commentstring = { enable = true, enable_autocmd = false },
			ensure_installed = ensure_installed,
		})

		-- -- INFO: Install any missing parsers
		-- -- WARN: Will not update, run `:TSUpdate`
		-- local parsers = require("nvim-treesitter.parsers")
		-- local missing_parsers = {}
		-- for _, lang in ipairs(ensure_installed) do
		-- 	if not parsers.has_parser(lang) then
		-- 		table.insert(missing_parsers, lang)
		-- 	end
		-- end
		-- if #missing_parsers > 0 then
		-- 	vim.cmd("TSUpdate " .. table.concat(missing_parsers, " "))
		-- end
	end,
}

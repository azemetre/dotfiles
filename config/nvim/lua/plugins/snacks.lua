-- #core #ux
---@type Utils.Pack.Spec
return {
	src = "https://github.com/folke/snacks.nvim",
	defer = true,
	---@type snacks.Config
	config = function()
		require("snacks").setup({
			bigfile = { enabled = true },
			input = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			words = { enabled = true },
			notifier = { enabled = true },
			image = { enabled = false },
			dashboard = { enabled = false },
			terminal = { enabled = false },
			explorer = { enabled = false },
			indent = { enabled = false },
			picker = { enabled = false },
			statuscolumn = { enabled = false },
			scroll = { enabled = false },
			lazygit = { enabled = false },
			styles = {
				notification = {},
			},
		})

		vim.keymap.set("n", "<leader>N", function()
			Snacks.win({
				file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
				width = 0.8,
				height = 0.9,
				wo = {
					spell = false,
					wrap = false,
					signcolumn = "yes",
					statuscolumn = " ",
					conceallevel = 3,
				},
			})
		end, { desc = "Neovim News" })

		_G.dd = function(...)
			Snacks.debug.inspect(...)
		end
		_G.bt = function()
			Snacks.debug.backtrace()
		end
		vim.print = _G.dd

		Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
		Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
		Snacks.toggle
			.option("relativenumber", { name = "Relative Number" })
			:map("<leader>uL")
		Snacks.toggle.diagnostics():map("<leader>ud")
		Snacks.toggle.line_number():map("<leader>ul")
		Snacks.toggle.inlay_hints():map("<leader>uh")
		Snacks.toggle.indent():map("<leader>ug")
	end,
}

-- #core #lsp #linting
---@type Utils.Pack.Spec
return {
	src = "https://github.com/stevearc/conform.nvim",
	config = function()
		local conform = require("conform")

		conform.setup({
			notify_on_error = false,
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				local disable_filetypes = { c = false, cpp = false }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua", stop_after_first = true },
				javascript = {
					"biome",
					"biome-organize-imports",
					stop_after_first = true,
				},
				typescript = {
					"biome",
					"biome-organize-imports",
					stop_after_first = true,
				},
				typescriptreact = {
					"biome",
					"biome-organize-imports",
					stop_after_first = true,
				},
				javascriptreact = {
					"biome",
					"biome-organize-imports",
					stop_after_first = true,
				},
			},
		})

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})

		vim.keymap.set("n", "<leader>uf", function()
			if vim.b.disable_autoformat then
				vim.cmd("FormatEnable")
				vim.notify("Enabled autoformat for current buffer")
			else
				vim.cmd("FormatDisable!")
				vim.notify("Disabled autoformat for current buffer")
			end
		end, { desc = "Toggle autoformat for current buffer" })

		vim.keymap.set("n", "<leader>uF", function()
			if vim.g.disable_autoformat then
				vim.cmd("FormatEnable")
				vim.notify("Enabled autoformat globally")
			else
				vim.cmd("FormatDisable")
				vim.notify("Disabled autoformat globally")
			end
		end, { desc = "Toggle autoformat globally" })
	end,
}

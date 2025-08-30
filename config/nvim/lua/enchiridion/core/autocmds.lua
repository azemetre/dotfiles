local group = "Init"
local utils_pack = require("utils.pack")

vim.api.nvim_create_augroup(group, { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
	group = group,
})
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(args)
		---@type string
		local kind = args.data.kind
		---@type Utils.Pack.Spec
		local spec = args.data.spec

		if kind == "install" or kind == "update" then
			utils_pack.build({ spec })
		end
	end,
	group = group,
})
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("clearjumps")
	end,
	group = group,
})
-- This file is automatically loaded by plugins.config

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd(
	{ "FocusGained", "TermClose", "TermLeave" },
	{ command = "checktime" }
)

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 125 })
	end,
	group = group,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"lspinfo",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"PlenaryTestPopup",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set(
			"n",
			"q",
			"<cmd>close<cr>",
			{ buffer = event.buf, silent = true }
		)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- add/removes go imports
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = { "*.go" },
-- 	callback = function()
-- 		local ONE_SECOND = 1000
-- 		local params = vim.lsp.util.make_range_params()
-- 		params.context = { only = { "source.organizeImports" } }
-- 		local result = vim.lsp.buf_request_sync(
-- 			0,
-- 			"textDocument/codeAction",
-- 			params,
-- 			ONE_SECOND
-- 		)
-- 		for _, res in pairs(result or {}) do
-- 			for _, r in pairs(res.result or {}) do
-- 				if r.edit then
-- 					vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
-- 				else
-- 					vim.lsp.buf.execute_command(r.command)
-- 				end
-- 			end
-- 		end
-- 	end,
-- })

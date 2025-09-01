local utils_pack = require("utils.pack")

local autocmds = {
	---@type vim.api.keyset.create_augroup
	augroup_options = { clear = true },
	group = "Init",
}

vim.api.nvim_create_augroup(autocmds.group, autocmds.augroup_options)

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
	group = autocmds.group,
	desc = "treesitter initialization",
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(args)
		---@type string
		local kind = args.data.kind

		if kind == "install" or kind == "update" then
			---@type Utils.Pack.Spec
			local spec = args.data.spec
			utils_pack.build({ spec })
		end
	end,
	group = autocmds.group,
	desc = "if `lua/plugins` dir is modified, build plugins",
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("clearjumps")
	end,
	group = autocmds.group,
	desc = "clear Jumps",
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	command = "checktime",
	desc = "check if we need to reload the file when it changed",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 125 })
	end,
	group = autocmds.group,
	desc = "highlight on Yank",
})

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
	desc = "go to last loc when opening a Buffer",
})

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
	desc = "close some filetypes with <q>",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
	desc = "enable spelling in gitcommit, markdown",
})

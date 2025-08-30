-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.
-- This actually just enables the lsp servers.

local custom_icons = require("enchiridion.theme").icons
local blink = require("blink.cmp")

-- LSP Keymaps following the same format as your keymaps file
local lsp_keymaps = {
	{ "ge", vim.diagnostic.open_float, desc = "Line Diagnostics" },
	{ "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
	{ "gr", vim.lsp.buf.references, desc = "References" },
	{ "gi", vim.lsp.buf.implementation, desc = "Goto Implementation" },
	{ "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
	{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
	{
		"K",
		function()
			vim.lsp.buf.hover({
				border = "double",
				max_width = 85,
				max_height = 25,
			})
		end,
		desc = "Hover",
	},
	{
		"gK",
		function()
			vim.lsp.buf.signature_help({
				border = "double",
				max_width = 85,
				max_height = 25,
			})
		end,
		desc = "Signature Help",
	},
	{ "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
	{ "gc", vim.lsp.buf.rename, desc = "Rename" },
	{
		"<leader>fv",
		function()
			vim.lsp.buf.format({ async = true })
		end,
		mode = { "n", "x" },
		desc = "Format",
	},
	{
		"<leader>ca",
		vim.lsp.buf.code_action,
		mode = { "n", "x" },
		desc = "Code Action",
	},
	{
		"gr",
		function()
			local fzf_ok, fzf = pcall(require, "fzf-lua")
			if fzf_ok then
				fzf.lsp_references()
			else
				vim.lsp.buf.references()
			end
		end,
		desc = "References",
	},
	{
		"gi",
		function()
			local fzf_ok, fzf = pcall(require, "fzf-lua")
			if fzf_ok then
				fzf.lsp_implementations()
			else
				vim.lsp.buf.implementation()
			end
		end,
		desc = "Goto Implementation",
	},
	{
		"gy",
		function()
			local fzf_ok, fzf = pcall(require, "fzf-lua")
			if fzf_ok then
				fzf.lsp_typedefs()
			else
				vim.lsp.buf.type_definition()
			end
		end,
		desc = "Goto Type Definition",
	},
	{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },

	-- Actions
	{
		"<leader>fv",
		function()
			vim.lsp.buf.format({ async = true })
		end,
		mode = { "n", "x" },
		desc = "Format",
	},
	{
		"<leader>ca",
		function()
			local fzf_ok, fzf = pcall(require, "fzf-lua")
			if fzf_ok then
				fzf.lsp_code_actions()
			else
				vim.lsp.buf.code_action()
			end
		end,
		mode = { "n", "x" },
		desc = "Code Action",
	},

	{
		"<leader>cd",
		function()
			local fzf_ok, fzf = pcall(require, "fzf-lua")
			if fzf_ok then
				fzf.diagnostics_document()
			else
				vim.diagnostic.setloclist()
			end
		end,
		desc = "Document Diagnostics",
	},
	{
		"<leader>cD",
		function()
			local fzf_ok, fzf = pcall(require, "fzf-lua")
			if fzf_ok then
				fzf.diagnostics_workspace()
			else
				vim.diagnostic.setqflist()
			end
		end,
		desc = "Workspace Diagnostics",
	},
}

-- Function to set up keymaps for a buffer
local function setup_lsp_keymaps(buffer)
	for _, keymap in ipairs(lsp_keymaps) do
		local opts = {
			buffer = buffer,
			desc = keymap.desc,
			silent = true,
		}

		local mode = keymap.mode or "n"
		local lhs = keymap[1]
		local rhs = keymap[2]

		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		setup_lsp_keymaps(event.buf)
	end,
})

-- Setup capabilities with safe blink.cmp integration
-- This is copied straight from blink
-- https://cmp.saghen.dev/installation#merging-lsp-capabilities
local capabilities = {
	textDocument = {
		foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		},
	},
}

capabilities = blink.get_lsp_capabilities(capabilities)

-- Diagnostics configuration
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = custom_icons.error,
			[vim.diagnostic.severity.WARN] = custom_icons.warning,
			[vim.diagnostic.severity.INFO] = custom_icons.info,
			[vim.diagnostic.severity.HINT] = custom_icons.hint,
		},
	},
	underline = true,
	severity_sort = true,
	update_in_insert = false,
	virtual_lines = false,
})

-- Setup language servers.
vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git" },
})

vim.lsp.enable({
	"astro",
	"awk_ls",
	"basedpyright",
	"bashls",
	"biome", -- js/ts formatter, linter
	"cssls",
	"docker_compose_language_service",
	"dockerls",
	"gopls",
	"html",
	"jsonls",
	"lua_ls",
	"marksman", -- markdown
	"postgres_lsp",
	"taplo", -- toml
	"vimls",
	"vtsls", -- typescript
	"yamlls",
	"zls", -- zig
})

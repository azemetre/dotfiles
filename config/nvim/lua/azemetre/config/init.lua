_G.Azemetre = require("azemetre.util")
local snacks = require("azemetre.plugins.snacks")

---@class AzemetreConfig: AzemetreOptions
local M = {}

M.version = "1.0.0" -- x-release-please-version
Azemetre.config = M

---@class AzemetreOptions
local defaults = {
	-- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
	---@type string|fun()
	colorscheme = function()
		require("tokyonight").load()
	end,
	-- load the default settings
	defaults = {
		autocmds = true, -- azemetre.config.autocmds
		keymaps = true, -- azemetre.config.keymaps
		-- azemetre.config.options can't be configured here since that's loaded before azemetre setup
		-- if you want to disable loading options, add `package.loaded["azemetre.config.options"] = true` to the top of your init.lua
	},
	-- icons used by other plugins
	-- stylua: ignore
	icons = {
		-- used with `feline.nvim`
		misc = {
			Dots = "󰇘",
			Devil = "",
			Bsd = "",
			Ghost = "",
			Lsp = " ",
		},
		system = {
			Linux = " ",
			Macos = " ",
			Windows = " ",
		},
		-- used with `nvim-tree`
		files = {
			Arrow_open = "",
			Arrow_closed = "",
			Default = "",
			Open = "",
			Empty = "",
			Empty_open = "",
			Symlink = "",
			Symlink_open = "",
			File = "",
			File_readonly = "",
			File_modified = "",
		},
		ft = {
			octo = "",
		},
		dap = {
			Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
			Breakpoint          = " ",
			BreakpointCondition = " ",
			BreakpointRejected  = { " ", "DiagnosticError" },
			LogPoint            = ".>",
		},
		diagnostics = {
			Error = " ",
			Warn  = " ",
			Hint  = " ",
			Info  = " ",
		},
		git = {
			Added     = " ",
			Modified  = " ",
			Removed   = " ",
			Git       = "",
			Unstaged  = "●",
			Staged    = "✓",
			Unmerged  = "",
			Renamed   = "➜",
			Untracked = "★",
			Deleted   = "",
			Ignored   = "◌",
		},
		kinds = {
			Array         = " ",
			Boolean       = "󰨙 ",
			Class         = " ",
			Codeium       = "󰘦 ",
			Color         = " ",
			Control       = " ",
			Collapsed     = " ",
			Constant      = "󰏿 ",
			Constructor   = " ",
			Copilot       = " ",
			Enum          = " ",
			EnumMember    = " ",
			Event         = " ",
			Field         = " ",
			File          = " ",
			Folder        = " ",
			Function      = "󰊕 ",
			Interface     = " ",
			Key           = " ",
			Keyword       = " ",
			Method        = "󰊕 ",
			Module        = " ",
			Namespace     = "󰦮 ",
			Null          = " ",
			Number        = "󰎠 ",
			Object        = " ",
			Operator      = " ",
			Package       = " ",
			Property      = " ",
			Reference     = " ",
			Snippet       = " ",
			String        = " ",
			Struct        = "󰆼 ",
			TabNine       = "󰏚 ",
			Text          = " ",
			TypeParameter = " ",
			Unit          = " ",
			Value         = " ",
			Variable      = "󰀫 ",
		},
	},
	---@type table<string, string[]|boolean>?
	kind_filter = {
		default = {
			"Class",
			"Constructor",
			"Enum",
			"Field",
			"Function",
			"Interface",
			"Method",
			"Module",
			"Namespace",
			"Package",
			"Property",
			"Struct",
			"Trait",
		},
		markdown = false,
		help = false,
		-- you can specify a different filter for each filetype
		lua = {
			"Class",
			"Constructor",
			"Enum",
			"Field",
			"Function",
			"Interface",
			"Method",
			"Module",
			"Namespace",
			-- "Package", -- remove package since luals uses it for control flow structures
			"Property",
			"Struct",
			"Trait",
		},
	},
}

M.json = {
	version = 6,
	path = vim.g.azemetre_json or vim.fn.stdpath("config") .. "/azemetre.json",
	data = {
		version = nil, ---@type string?
	},
}

---@type AzemetreOptions
local options
local lazy_clipboard

---@param opts? AzemetreOptions
function M.setup(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

	-- autocmds can be loaded lazily when not opening a file
	local lazy_autocmds = vim.fn.argc(-1) == 0
	if not lazy_autocmds then
		M.load("autocmds")
	end

	local group = vim.api.nvim_create_augroup("Azemetre", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "VeryLazy",
		callback = function()
			if lazy_autocmds then
				M.load("autocmds")
			end
			M.load("keymaps")
			if lazy_clipboard ~= nil then
				vim.opt.clipboard = lazy_clipboard
			end
		end,
	})
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
	local function _load(mod)
		if require("lazy.core.cache").find(mod)[1] then
			Azemetre.try(function()
				require(mod)
			end, { msg = "Failed loading " .. mod })
		end
	end
	local pattern = "Azemetre" .. name:sub(1, 1):upper() .. name:sub(2)
	-- always load azemetre, then user file
	if M.defaults[name] or name == "options" then
		_load("azemetre.config." .. name)
		vim.api.nvim_exec_autocmds(
			"User",
			{ pattern = pattern .. "Defaults", modeline = false }
		)
	end
	_load("config." .. name)
	if vim.bo.filetype == "lazy" then
		-- HACK: Azemetre may have overwritten options of the Lazy ui, so reset this here
		vim.cmd([[do VimResized]])
	end
	vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

M.did_init = false
function M.init()
	if M.did_init then
		return
	end
	M.did_init = true
	local plugin = require("lazy.core.config").spec.plugins.Azemetre
	if plugin then
		vim.opt.rtp:append(plugin.dir)
	end

	-- load options here, before lazy init while sourcing plugin modules
	-- this is needed to make sure options will be correctly applied
	-- after installing missing plugins
	M.load("options")
end

setmetatable(M, {
	__index = function(_, key)
		if options == nil then
			return vim.deepcopy(defaults)[key]
		end
		---@cast options AzemetreConfig
		return options[key]
	end,
})

return M

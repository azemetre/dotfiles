_G.Enchiridion = require("enchiridion.util")

---@class EnchiridionConfig: EnchiridionOptions
local M = {}

M.version = "1.0.0" -- x-release-please-version
Enchiridion.config = M

---@class EnchiridionOptions
local defaults = {
	-- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
	---@type string|fun()
	colorscheme = function()
		require("tokyonight").load()
	end,
	-- load the default settings
	defaults = {
		autocmds = true, -- enchiridion.config.autocmds
		keymaps = true, -- enchiridion.config.keymaps
		-- enchiridion.config.options can't be configured here since that's loaded before enchiridion setup
		-- if you want to disable loading options, add `package.loaded["enchiridion.config.options"] = true` to the top of your init.lua
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
	path = vim.g.enchiridion_json
		or vim.fn.stdpath("config") .. "/enchiridion.json",
	data = {
		version = nil, ---@type string?
	},
}

---@type EnchiridionOptions
local options
local lazy_clipboard

---@param opts? EnchiridionOptions
function M.setup(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

	-- autocmds can be loaded lazily when not opening a file
	local lazy_autocmds = vim.fn.argc(-1) == 0
	if not lazy_autocmds then
		M.load("autocmds")
	end

	local group = vim.api.nvim_create_augroup("Enchiridion", { clear = true })
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
			Enchiridion.try(function()
				require(mod)
			end, { msg = "Failed loading " .. mod })
		end
	end
	local pattern = "Enchiridion" .. name:sub(1, 1):upper() .. name:sub(2)
	-- always load enchiridion, then user file
	if M.defaults[name] or name == "options" then
		_load("enchiridion.config." .. name)
		vim.api.nvim_exec_autocmds(
			"User",
			{ pattern = pattern .. "Defaults", modeline = false }
		)
	end
	_load("config." .. name)
	if vim.bo.filetype == "lazy" then
		-- HACK: Enchiridion may have overwritten options of the Lazy ui, so reset this here
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
	local plugin = require("lazy.core.config").spec.plugins.Enchiridion
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
		---@cast options EnchiridionConfig
		return options[key]
	end,
})

return M

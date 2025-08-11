local Plugin = require("lazy.core.plugin")

---@class azemetre.util.plugin
local M = {}

---@type string[]
M.core_imports = {}

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

---@type table<string, string>
M.deprecated_extras = {}

M.deprecated_modules = {}

---@type table<string, string>
M.renames = {}

function M.save_core()
	if vim.v.vim_did_enter == 1 then
		return
	end
	M.core_imports = vim.deepcopy(require("lazy.core.config").spec.modules)
end

function M.setup()
	M.fix_renames()
	M.lazy_file()
	table.insert(package.loaders)
end

function M.extra_idx(name)
	local Config = require("lazy.core.config")
	for i, extra in ipairs(Config.spec.modules) do
		if extra == "azemetre.plugins.extras." .. name then
			return i
		end
	end
end

function M.lazy_file()
	-- This autocmd will only trigger when a file was loaded from the cmdline.
	-- It will render the file as quickly as possible.
	vim.api.nvim_create_autocmd("BufReadPost", {
		once = true,
		callback = function(event)
			-- Skip if we already entered vim
			if vim.v.vim_did_enter == 1 then
				return
			end

			-- Try to guess the filetype (may change later on during Neovim startup)
			local ft = vim.filetype.match({ buf = event.buf })
			if ft then
				-- Add treesitter highlights and fallback to syntax
				local lang = vim.treesitter.language.get_lang(ft)
				if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then
					vim.bo[event.buf].syntax = ft
				end

				-- Trigger early redraw
				vim.cmd([[redraw]])
			end
		end,
	})

	-- Add support for the LazyFile event
	local Event = require("lazy.core.handler.event")

	Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
	Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

function M.fix_imports()
	Plugin.Spec.import = Azemetre.inject.args(
		Plugin.Spec.import,
		function(_, spec)
			local dep = M.deprecated_extras[spec and spec.import]
			if dep then
				dep = dep
					.. "\n"
					.. "Please remove the extra from `azemetre.json` to hide this warning."
				Azemetre.warn(dep, {
					title = "Azemetre",
					once = true,
					stacktrace = true,
					stacklevel = 6,
				})
				return false
			end
		end
	)
end

function M.fix_renames()
	Plugin.Spec.add = Azemetre.inject.args(
		Plugin.Spec.add,
		function(self, plugin)
			if type(plugin) == "table" then
				if M.renames[plugin[1]] then
					Azemetre.warn(
						("Plugin `%s` was renamed to `%s`.\nPlease update your config for `%s`"):format(
							plugin[1],
							M.renames[plugin[1]],
							self.importing or "Azemetre"
						),
						{ title = "Azemetre" }
					)
					plugin[1] = M.renames[plugin[1]]
				end
			end
		end
	)
end

return M

-- Set the global namespace
-- taken from my initials
local M = {}
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h:h")

---@param plugin string
function M.has(plugin)
	return require("lM..core.config").plugins[plugin] ~= nil
end

---Source a lua or vimscript file
---@param path string path relative to the nvim directory
---@param prefix boolean?
function M.source(path, prefix)
	if not prefix then
		vim.cmd(string.format("source %s", path))
	else
		vim.cmd(string.format("source %s/%s", vim.g.vim_dir, path))
	end
end

---Require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function M.safe_require(module, opts)
	opts = opts or { silent = false }
	local ok, result = pcall(require, module)
	if not ok and not opts.silent then
		vim.notify(result, vim.log.levels.ERROR, { title = string.format("Error requiring: %s", module) })
	end
	return ok, result
end

---Determine if a table contains a value
---@param tbl table
---@param value string
---@return boolean
function M.contains(tbl, value)
	return tbl[value] ~= nil
end

---Pretty print a table
---@param tbl table
---@return table
function M.print_table(tbl)
	return require("pl.pretty").dump(tbl)
end

---Get values for a given highlight group
---@param name string
---@return table
function M.get_highlight(name)
	local hl = vim.api.nvim_get_hl_by_name(name, vim.o.termguicolors)
	if vim.o.termguicolors then
		hl.fg = hl.foreground
		hl.bg = hl.background
		hl.sp = hl.special
		hl.foreground = nil
		hl.background = nil
		hl.special = nil
	else
		hl.ctermfg = hl.foreground
		hl.ctermbg = hl.background
		hl.foreground = nil
		hl.background = nil
		hl.special = nil
	end
	return hl
end

---Invalidate lua modules
---@param path string
---@param recursive boolean
function M.invalidate(path, recursive)
	if recursive then
		for key, value in pairs(package.loaded) do
			if key ~= "_G" and value and vim.fn.match(key, path) ~= -1 then
				package.loaded[key] = nil
				require(key)
			end
		end
	else
		package.loaded[path] = nil
		require(path)
	end
end

---Return true if any pattern in the tbl matches the provided value
---@param tbl table
---@param val string
---@return boolean
function M.find_pattern_match(tbl, val)
	return tbl and next(vim.tbl_filter(function(pattern)
		return val:match(pattern)
	end, tbl))
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

---@param name string
function M.opts(name)
	local plugin = require("lM..core.config").plugins[name]
	if not plugin then
		return {}
	end
	local Plugin = require("lM..core.plugin")
	return Plugin.values(plugin, "opts", false)
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
	---@type string?
	local path = vim.api.nvim_buf_get_name(0)
	path = path ~= "" and vim.loop.fs_realpath(path) or nil
	---@type string[]
	local roots = {}
	if path then
		for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			local workspace = client.config.workspace_folders
			local paths = workspace
					and vim.tbl_map(function(ws)
						return vim.uri_to_fname(ws.uri)
					end, workspace)
				or client.config.root_dir and { client.config.root_dir }
				or {}
			for _, p in ipairs(paths) do
				local r = vim.loop.fs_realpath(p)
				if path:find(r, 1, true) then
					roots[#roots + 1] = r
				end
			end
		end
	end
	table.sort(roots, function(a, b)
		return #a > #b
	end)
	---@type string?
	local root = roots[1]
	if not root then
		path = path and vim.fs.dirname(path) or vim.loop.cwd()
		---@type string?
		root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
		root = root and vim.fs.dirname(root) or vim.loop.cwd()
	end
	---@cast root string
	return root
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
	if values then
		if vim.opt_local[option]:get() == values[1] then
			vim.opt_local[option] = values[2]
		else
			vim.opt_local[option] = values[1]
		end
		return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
	end
	vim.opt_local[option] = not vim.opt_local[option]:get()
	if not silent then
		if vim.opt_local[option]:get() then
			Util.info("Enabled " .. option, { title = "Option" })
		else
			Util.warn("Disabled " .. option, { title = "Option" })
		end
	end
end

local enabled = true
function M.toggle_diagnostics()
	enabled = not enabled
	if enabled then
		vim.diagnostic.enable()
		Util.info("Enabled diagnostics", { title = "Diagnostics" })
	else
		vim.diagnostic.disable()
		Util.warn("Disabled diagnostics", { title = "Diagnostics" })
	end
end

function M.deprecate(old, new)
	Util.warn(("`%s` is deprecated. Please use `%s` instead"):format(old, new), { title = "LM.Vim" })
end

return M

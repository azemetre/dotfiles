local Float = require("lazy.view.float")
local AzemetreConfig = require("lazy.core.config")
local Plugin = require("lazy.core.plugin")
local Text = require("lazy.view.text")

---@class AzemetreExtraSource
---@field name string
---@field desc? string
---@field module string

---@class AzemetreExtra
---@field name string
---@field source AzemetreExtraSource
---@field module string
---@field desc? string
---@field enabled boolean
---@field managed boolean
---@field recommended? boolean
---@field imports string[]
---@field row? number
---@field section? string
---@field plugins string[]
---@field optional string[]

---@class azemetre.util.extras
local M = {}
M.buf = 0

---@type AzemetreExtraSource[]
M.sources = {
	{
		name = "Azemetre",
		desc = "Azemetre extras",
		module = "azemetre.plugins.extras",
	},
	{ name = "User", desc = "User extras", module = "plugins.extras" },
}

M.ns = vim.api.nvim_create_namespace("azemetre.extras")
---@type string[]
M.state = nil

---@alias WantsOpts {ft?: string|string[], root?: string|string[]}

---@param opts WantsOpts
---@return boolean
function M.wants(opts)
	if opts.ft then
		opts.ft = type(opts.ft) == "string" and { opts.ft } or opts.ft
		for _, f in ipairs(opts.ft) do
			if vim.bo[M.buf].filetype == f then
				return true
			end
		end
	end
	if opts.root then
		opts.root = type(opts.root) == "string" and { opts.root } or opts.root
		return #Azemetre.root.detectors.pattern(M.buf, opts.root) > 0
	end
	return false
end

---@return AzemetreExtra[]
function M.get()
	M.state = M.state or AzemetreConfig.spec.modules
	local extras = {} ---@type AzemetreExtra[]
	for _, source in ipairs(M.sources) do
		local root = Azemetre.find_root(source.module)
		if root then
			Azemetre.walk(root, function(path, name, type)
				if (type == "file" or type == "link") and name:match("%.lua$") then
					name = path:sub(#root + 2, -5):gsub("/", ".")
					local ok, extra =
						pcall(M.get_extra, source, source.module .. "." .. name)
					if ok then
						extras[#extras + 1] = extra
					end
				end
			end)
		end
	end
	table.sort(extras, function(a, b)
		return a.name < b.name
	end)
	return extras
end

---@param modname string
---@param source AzemetreExtraSource
function M.get_extra(source, modname)
	local enabled = vim.tbl_contains(M.state, modname)
	local spec = Plugin.Spec.new(nil, { optional = true, pkg = false })
	spec:parse({ import = modname })
	local imports = vim.tbl_filter(function(x)
		return x ~= modname
	end, spec.modules)
	if #imports > 0 then
		spec = Plugin.Spec.new(nil, { optional = true, pkg = false })
		spec.modules = vim.deepcopy(imports)
		spec:parse({ import = modname })
	end
	local plugins = {} ---@type string[]
	local optional = {} ---@type string[]
	for _, p in pairs(spec.plugins) do
		if p.optional then
			optional[#optional + 1] = p.name
		else
			plugins[#plugins + 1] = p.name
		end
	end
	table.sort(plugins)
	table.sort(optional)

	---@type boolean|(fun():boolean?)|nil|WantsOpts
	local recommended = require(modname).recommended or false
	if type(recommended) == "function" then
		recommended = recommended() or false
	elseif type(recommended) == "table" then
		recommended = M.wants(recommended)
	end

	---@type AzemetreExtra
	return {
		source = source,
		name = modname:sub(#source.module + 2),
		module = modname,
		enabled = enabled,
		imports = imports,
		desc = require(modname).desc,
		recommended = recommended,
		managed = vim.tbl_contains(Azemetre.config.json.data.extras, modname)
			or not enabled,
		plugins = plugins,
		optional = optional,
	}
end

---@class AzemetreExtraView
---@field float AzemetreFloat
---@field text Text
---@field extras AzemetreExtra[]
---@field diag AzemetreDiagnostic[]
local X = {}

---@return AzemetreExtraView
function X.new()
	local self = setmetatable({}, { __index = X })
	M.buf = vim.api.nvim_get_current_buf()
	self.float = Float.new({ title = "Azemetre Extras" })
	self.float:on_key("x", function()
		self:toggle()
	end, "Toggle extra")
	self.diag = {}
	self:update()
	return self
end

---@param diag AzemetreDiagnostic
function X:diagnostic(diag)
	diag.row = diag.row or self.text:row()
	diag.severity = diag.severity or vim.diagnostic.severity.INFO
	table.insert(self.diag, diag)
end

function X:toggle()
	local pos = vim.api.nvim_win_get_cursor(self.float.win)
	for _, extra in ipairs(self.extras) do
		if extra.row == pos[1] then
			if not extra.managed then
				Azemetre.error(
					"Not managed by AzemetreExtras. Remove from your config to enable/disable here.",
					{ title = "AzemetreExtras" }
				)
				return
			end
			extra.enabled = not extra.enabled
			Azemetre.config.json.data.extras = vim.tbl_filter(function(name)
				return name ~= extra.module
			end, Azemetre.config.json.data.extras)
			M.state = vim.tbl_filter(function(name)
				return name ~= extra.module
			end, M.state)
			if extra.enabled then
				table.insert(Azemetre.config.json.data.extras, extra.module)
				M.state[#M.state + 1] = extra.module
			end
			table.sort(Azemetre.config.json.data.extras)
			Azemetre.json.save()
			Azemetre.info(
				"`"
					.. extra.name
					.. "`"
					.. " "
					.. (extra.enabled and "**enabled**" or "**disabled**")
					.. "\nPlease restart Azemetre to apply the changes.",
				{ title = "AzemetreExtras" }
			)
			self:update()
			return
		end
	end
end

function X:update()
	self.diag = {}
	self.extras = M.get()
	self.text = Text.new()
	self.text.padding = 2
	self:render()
	self.text:trim()
	vim.bo[self.float.buf].modifiable = true
	self.text:render(self.float.buf)
	vim.bo[self.float.buf].modifiable = false
	vim.diagnostic.set(
		M.ns,
		self.float.buf,
		---@param diag AzemetreDiagnostic
		vim.tbl_map(function(diag)
			diag.col = 0
			diag.lnum = diag.row - 1
			return diag
		end, self.diag),
		{ signs = false, virtual_text = true, underline = false }
	)
end

function X:render()
	self.text:nl():nl():append("Azemetre Extras", "AzemetreH1"):nl():nl()
	self.text
		:append(
			"This is a list of all enabled/disabled Azemetre extras.",
			"AzemetreComment"
		)
		:nl()
		:append(
			"Each extra shows the required and optional plugins it may install.",
			"AzemetreComment"
		)
		:nl()
		:append("Enable/disable extras with the ", "AzemetreComment")
		:append("<x>", "AzemetreSpecial")
		:append(" key", "AzemetreComment")
		:nl()
	for _, extra in ipairs(self.extras) do
		extra.section = nil
	end
	self:section({
		recommended = true,
		enabled = false,
		include = "^lang%.",
		title = "Recommended Languages",
		empty = false,
	})
	self:section({
		enabled = true,
		exclude = "^lang%.",
		title = "Enabled Plugins",
	})
	self:section({ enabled = true, title = "Enabled Languages" })
	self:section({
		recommended = true,
		title = "Recommended Plugins",
		empty = false,
	})
	self:section({ title = "Plugins", exclude = "^lang%." })
	self:section({ title = "Languages" })
end

---@param extra AzemetreExtra
function X:extra(extra)
	if not extra.managed then
		---@type AzemetreExtra[]
		local parents = {}
		for _, x in ipairs(self.extras) do
			if x.enabled and vim.tbl_contains(x.imports, extra.module) then
				parents[#parents + 1] = x
			end
		end
		if #parents > 0 then
			local pp = vim.tbl_map(function(x)
				return x.name
			end, parents)
			self:diagnostic({
				message = "Required by " .. table.concat(pp, ", "),
			})
		elseif vim.tbl_contains(Azemetre.plugin.core_imports, extra.module) then
			self:diagnostic({
				message = "This extra is included by default",
			})
		else
			self:diagnostic({
				message = "Not managed by AzemetreExtras (config)",
				severity = vim.diagnostic.severity.WARN,
			})
		end
	end
	extra.row = self.text:row()
	local hl = extra.managed and "AzemetreSpecial" or "AzemetreLocal"
	if extra.enabled then
		self.text:append(
			"  " .. AzemetreConfig.options.ui.icons.loaded .. " ",
			hl
		)
	else
		self.text:append(
			"  " .. AzemetreConfig.options.ui.icons.not_loaded .. " ",
			hl
		)
	end
	self.text:append(extra.name)
	if extra.recommended then
		self.text:append(" "):append(
			AzemetreConfig.options.ui.icons.favorite or " ",
			"AzemetreCommit"
		)
	end
	if extra.source.name ~= "Azemetre" then
		self.text:append(" "):append(
			AzemetreConfig.options.ui.icons.event .. extra.source.name,
			"AzemetreReasonEvent"
		)
	end
	for _, import in ipairs(extra.imports) do
		import = import:gsub("^azemetre.plugins.extras.", "")
		self.text:append(" "):append(
			AzemetreConfig.options.ui.icons.plugin .. import,
			"AzemetreReasonStart"
		)
	end
	for _, plugin in ipairs(extra.plugins) do
		self.text:append(" "):append(
			AzemetreConfig.options.ui.icons.plugin .. plugin,
			"AzemetreReasonPlugin"
		)
	end
	for _, plugin in ipairs(extra.optional) do
		self.text:append(" "):append(
			AzemetreConfig.options.ui.icons.plugin .. plugin,
			"AzemetreReasonRequire"
		)
	end
	if extra.desc then
		self.text:nl():append("    " .. extra.desc, "AzemetreComment")
	end
	self.text:nl()
end

---@param opts {enabled?:boolean, title:string, recommended?:boolean, include?:string, exclude?:string, empty?:boolean}
function X:section(opts)
	opts = opts or {}
	---@type AzemetreExtra[]
	local extras = vim.tbl_filter(function(extra)
		return extra.section == nil
			and (opts.enabled == nil or extra.enabled == opts.enabled)
			and (opts.recommended == nil or extra.recommended == opts.recommended)
			and (opts.include == nil or extra.name:find(opts.include))
			and (opts.exclude == nil or not extra.name:find(opts.exclude))
	end, self.extras)

	if opts.empty == false and #extras == 0 then
		return
	end

	self.text
		:nl()
		:append(opts.title .. ":", "AzemetreH2")
		:append(" (" .. #extras .. ")", "AzemetreComment")
		:nl()
	for _, extra in ipairs(extras) do
		extra.section = opts.title
		self:extra(extra)
	end
end

function M.show()
	return X.new()
end

return M

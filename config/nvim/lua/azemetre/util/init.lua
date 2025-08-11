local AzemetreUtil = require("lazy.core.util")

---@class azemetre.util: AzemetreUtilCore
---@field config AzemetreConfig
---@field inject azemetre.util.inject
local M = {}

setmetatable(M, {
	__index = function(t, k)
		if AzemetreUtil[k] then
			return AzemetreUtil[k]
		end
		---@diagnostic disable-next-line: no-unknown
		t[k] = require("azemetre.util." .. k)
		return t[k]
	end,
})

return M

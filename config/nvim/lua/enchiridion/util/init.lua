local EnchiridionUtil = require("lazy.core.util")

---@class enchiridion.util: EnchiridionUtilCore
---@field config EnchiridionConfig
---@field inject enchiridion.util.inject
local M = {}

setmetatable(M, {
	__index = function(t, k)
		if EnchiridionUtil[k] then
			return EnchiridionUtil[k]
		end
		---@diagnostic disable-next-line: no-unknown
		t[k] = require("enchiridion.util." .. k)
		return t[k]
	end,
})

return M

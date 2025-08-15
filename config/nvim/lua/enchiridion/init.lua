vim.uv = vim.uv or vim.loop

local M = {}

---@param opts? EnchiridionConfig
function M.setup(opts)
	require("enchiridion.config").setup(opts)
end

return M

vim.uv = vim.uv or vim.loop

local M = {}

---@param opts? AzemetreConfig
function M.setup(opts)
	require("azemetre.config").setup(opts)
end

return M

-- #editor #core
-- buffer remove
---@type Utils.Pack.Spec
return {
	src = "https://github.com/nvim-mini/mini.bufremove",
	defer = true,
	config = function()
		require("mini.bufremove").setup()

		vim.keymap.set("n", "<leader>bd", function()
			require("mini.bufremove").delete(0, false)
		end, { desc = "Delete Buffer" })
		vim.keymap.set("n", "<leader>bD", function()
			require("mini.bufremove").delete(0, true)
		end, { desc = "Delete Buffer (Force)" })
	end,
}

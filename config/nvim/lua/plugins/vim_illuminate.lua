-- #editor #text #search
-- references
---@type Utils.Pack.Spec
return {
	src = "https://github.com/RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
			delay = 200,
		})

		vim.keymap.set("n", "]]", function()
			require("illuminate").goto_next_reference(false)
		end, { desc = "next reference" })
		vim.keymap.set("n", "[[", function()
			require("illuminate").goto_prev_reference(false)
		end, { desc = "prev reference" })
	end,
}

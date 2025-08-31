-- #todo #comments #editor #ui
-- PERF:
-- HACK:
-- TODO:
-- FIX:
-- NOTE:
-- INFO:
-- WARNING:
---@type Utils.Pack.Spec
return {
	src = "https://github.com/folke/todo-comments.nvim",
	config = function()
		require("todo-comments").setup({
			keywords = {
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			},
		})

		vim.keymap.set("n", "]t", function()
			require("todo-comments").jump_next()
		end, { desc = "Next todo comment" })
		vim.keymap.set("n", "[t", function()
			require("todo-comments").jump_prev()
		end, { desc = "Previous todo comment" })
		vim.keymap.set(
			"n",
			"<leader>xt",
			"<cmd>TodoTrouble<cr>",
			{ desc = "Todo Trouble" }
		)
		vim.keymap.set(
			"n",
			"<leader>xtt",
			"<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",
			{ desc = "Todo Trouble" }
		)
		vim.keymap.set(
			"n",
			"<leader>fd",
			"<cmd>FzfLua diagnostics_document<cr>",
			{ desc = "Document Diagnostics" }
		)
		vim.keymap.set(
			"n",
			"<leader>fw",
			"<cmd>FzfLua diagnostics_workspace<cr>",
			{ desc = "Workspace Diagnostics" }
		)
	end,
}

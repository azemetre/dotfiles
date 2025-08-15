-- #todo #comments #editor #ui
-- PERF:
-- HACK:
-- TODO:
-- FIX:
-- NOTE:
-- WARNING:
return {
	"folke/todo-comments.nvim",
	cmd = { "TodoTrouble", "TodoTelescope" },
	event = "BufReadPost",
	opts = {
		keywords = {
			NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
		},
	},
	config = true,
		-- stylua: ignore
		keys = {
			{ "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
			{ "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
			{ "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
			{ "<leader>xtt", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo Trouble" },
			{ "<leader>xf", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
			{ "<leader>xd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
			{ "<leader>xw", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
		},
}

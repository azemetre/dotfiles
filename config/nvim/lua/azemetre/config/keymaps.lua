-- This file is automatically loaded by azemetre.plugins.config,

-- FIXME: document all keymaps

-- Clear search with <esc> or <cr>
vim.keymap.set(
	{ "i", "n" },
	"<esc>",
	"<cmd>noh<cr><esc>",
	{ desc = "Escape and clear hlsearch" }
)
vim.keymap.set(
	{ "n" },
	"<leader><cr>",
	"<cmd>noh<cr>",
	{ desc = "Enter and clear hlsearch" }
)
vim.keymap.set("n", "gw", "*N")
vim.keymap.set("x", "gw", "*N")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set(
	"n",
	"n",
	"'Nn'[v:searchforward]",
	{ expr = true, desc = "Next search result" }
)
vim.keymap.set(
	"x",
	"n",
	"'Nn'[v:searchforward]",
	{ expr = true, desc = "Next search result" }
)
vim.keymap.set(
	"o",
	"n",
	"'Nn'[v:searchforward]",
	{ expr = true, desc = "Next search result" }
)
vim.keymap.set(
	"n",
	"N",
	"'nN'[v:searchforward]",
	{ expr = true, desc = "Prev search result" }
)
vim.keymap.set(
	"x",
	"N",
	"'nN'[v:searchforward]",
	{ expr = true, desc = "Prev search result" }
)
vim.keymap.set(
	"o",
	"N",
	"'nN'[v:searchforward]",
	{ expr = true, desc = "Prev search result" }
)

-- visually move selection
vim.keymap.set(
	{ "v", "o" },
	"J",
	":m '>+1<CR>gv=gv",
	{ desc = "Move visual selection down" }
)
vim.keymap.set(
	{ "v", "o" },
	"K",
	":m '<-2<CR>gv=gv",
	{ desc = "Move visual selection up" }
)

-- lazy
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

vim.keymap.set(
	"n",
	"<leader>xl",
	"<cmd>lopen<cr>",
	{ desc = "Open Location List" }
)
vim.keymap.set(
	"n",
	"<leader>xf",
	"<cmd>copen<cr>",
	{ desc = "Open Quickfix List" }
)

-- stylua: ignore start

-- toggle options
-- vim.keymap.set("n", "<leader>uf", function() Snacks.toggle.option("autoformat", { name = "Format on Save" }) end, { desc = "Toggle Format" })
-- vim.keymap.set("n", "<leader>uF", function() Azemetre.format() end, { desc = "Toggle Format (buffer)" })
-- vim.keymap.set("n", "<leader>us", function() Snacks.toggle.option("spell", { name = "Spelling" }) end, { desc = "Toggle Spelling" })
-- vim.keymap.set("n", "<leader>uw", function() Snacks.toggle.option("wrap", { name = "Wrap" }) end, { desc = "Toggle Line Wrap" })
-- vim.keymap.set("n", "<leader>uL", function() Snacks.toggle.option("relativenumber", { name = "Relative Number" }) end, { desc = "Toggle Relative Number" })
-- vim.keymap.set("n", "<leader>ud", function() Snacks.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })
-- vim.keymap.set("n", "<leader>ul", function() Snacks.toggle.line_number() end, { desc = "Toggle Line Numbers" })
-- vim.keymap.set("n", "<leader>uT", function() Snacks.toggle.treesitter() end, { desc = "Toggle Treesitter" })
-- vim.keymap.set("n", "<leader>ub", function()
--   Snacks.toggle.option("background", {
--     values = { "light", "dark" },
--     name = "Background"
--   })
-- end, { desc = "Toggle Background" })

-- oil
vim.keymap.set("n", "<leader>-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

-- ufo - folding
vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open All Folds" })
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close All Folds" })
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open Folds Except" })
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close Folds With" })

-- Option to see the folded lines count
vim.keymap.set("n", "K", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
        vim.lsp.buf.hover()
    end
end)

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- highlights under cursor
vim.keymap.set("n", "<leader>hl", vim.show_pos, { desc = "Highlight Groups at cursor" })

-- buffers
vim.keymap.set("n", "<leader>b]", "<cmd>:BufferLineCycleNext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>:e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>b[", "<cmd>:BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>:e #<cr>", { desc = "Switch to Other Buffer" })

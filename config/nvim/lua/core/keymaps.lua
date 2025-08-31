-- FIXME: document all keymaps

---@type vim.keymap.set.Opts
local options = { silent = true }

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

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- highlights under cursor
vim.keymap.set(
	"n",
	"<leader>hl",
	vim.show_pos,
	{ desc = "Highlight Groups at cursor" }
)

-- buffers
vim.keymap.set(
	"n",
	"<leader>b]",
	"<cmd>:BufferLineCycleNext<CR>",
	{ desc = "Next Buffer" }
)
vim.keymap.set(
	"n",
	"<leader>bb",
	"<cmd>:e #<cr>",
	{ desc = "Switch to Other Buffer" }
)
vim.keymap.set(
	"n",
	"<leader>b[",
	"<cmd>:BufferLineCyclePrev<CR>",
	{ desc = "Previous Buffer" }
)
vim.keymap.set(
	"n",
	"<leader>`",
	"<cmd>:e #<cr>",
	{ desc = "Switch to Other Buffer" }
)

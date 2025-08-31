---@type vim.keymap.set.Opts
local options = { silent = true }

-- NOTE: think of the `mapleader` as your staff, every vimmer has one tailored
-- to their needs. Don't be afraid to try out different staffs, use what makes
-- you comfortable when casting motions.
vim.g.mapleader = ","

vim.keymap.set(
	{ "i", "n" },
	"<esc>",
	"<cmd>noh<cr><esc>",
	{ desc = "escape and clear hlsearch" }
)
vim.keymap.set(
	{ "n" },
	"<leader><cr>",
	"<cmd>noh<cr>",
	{ desc = "enter and clear hlsearch" }
)
vim.keymap.set("n", "gw", "*N")
vim.keymap.set("x", "gw", "*N")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set(
	"n",
	"n",
	"'Nn'[v:searchforward]",
	{ expr = true, desc = "next Search result" }
)
vim.keymap.set(
	"x",
	"n",
	"'Nn'[v:searchforward]",
	{ expr = true, desc = "next Search result" }
)
vim.keymap.set(
	"o",
	"n",
	"'Nn'[v:searchforward]",
	{ expr = true, desc = "next Search result" }
)
vim.keymap.set(
	"n",
	"N",
	"'nN'[v:searchforward]",
	{ expr = true, desc = "prev Search result" }
)
vim.keymap.set(
	"x",
	"N",
	"'nN'[v:searchforward]",
	{ expr = true, desc = "prev Search result" }
)
vim.keymap.set(
	"o",
	"N",
	"'nN'[v:searchforward]",
	{ expr = true, desc = "prev Search result" }
)

vim.keymap.set(
	{ "v", "o" },
	"J",
	":m '>+1<CR>gv=gv",
	{ desc = "move Visual Selection down" }
)
vim.keymap.set(
	{ "v", "o" },
	"K",
	":m '<-2<CR>gv=gv",
	{ desc = "move Visual Selection up" }
)

vim.keymap.set(
	"n",
	"<leader>xl",
	"<cmd>lopen<cr>",
	{ desc = "open Location List" }
)
vim.keymap.set(
	"n",
	"<leader>xf",
	"<cmd>copen<cr>",
	{ desc = "open Quickfix List" }
)

vim.keymap.set(
	"n",
	"<leader>qq",
	"<cmd>qa<cr>",
	{ desc = "Quit all, does not save" }
)

vim.keymap.set(
	"n",
	"<leader>hl",
	vim.show_pos,
	{ desc = "Highlight Groups under cursor" }
)

vim.keymap.set(
	"n",
	"<leader>b]",
	"<cmd>:BufferLineCycleNext<CR>",
	{ desc = "next Buffer" }
)
vim.keymap.set(
	"n",
	"<leader>bb",
	"<cmd>:e #<cr>",
	{ desc = "alternate previous Buffer" }
)
vim.keymap.set(
	"n",
	"<leader>`",
	"<cmd>:e #<cr>",
	{ desc = "alternate previous Buffer" }
)
vim.keymap.set(
	"n",
	"<leader>b[",
	"<cmd>:BufferLineCyclePrev<CR>",
	{ desc = "previous Buffer" }
)

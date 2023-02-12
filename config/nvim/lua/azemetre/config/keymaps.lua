-- This file is automatically loaded by lazyvim.plugins.config

local util = require("azemetre.util")

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
  "<cr>",
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
vim.keymap.set({"v", "o"}, "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set({"v", "o"}, "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- lazy
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- new file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

vim.keymap.set(
  "n",
  "<leader>xl",
  "<cmd>lopen<cr>",
  { desc = "Open Location List" }
)
vim.keymap.set(
  "n",
  "<leader>xq",
  "<cmd>copen<cr>",
  { desc = "Open Quickfix List" }
)

-- stylua: ignore start

-- toggle options
vim.keymap.set("n", "<leader>tf", require("azemetre.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
vim.keymap.set("n", "<leader>ts", function() util.toggle("spell") end, { desc = "Toggle Spelling" })
vim.keymap.set("n", "<leader>tw", function() util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
vim.keymap.set("n", "<leader>tn", function() util.toggle("relativenumber", true) util.toggle("number") end, { desc = "Toggle Line Numbers" })

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
    vim.keymap.set("n", "<leader>hl", vim.show_pos, { desc = "Highlight Groups at cursor" })
end

-- buffers
vim.keymap.set("n", "<leader>b]", "<cmd>:BufferLineCycleNext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>:e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>b[", "<cmd>:BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>:e #<cr>", { desc = "Switch to Other Buffer" })

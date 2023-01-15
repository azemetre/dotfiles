-- This file is automatically loaded by plugins.config

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- system level
vim.opt.autowrite = true -- enable auto write
vim.opt.backspace = { "indent", "eol,start" } -- make backspace behave in a sane manner
vim.opt.clipboard = { "unnamed", "unnamedplus" } -- sync with system clipboard
vim.opt.mouse = "a" -- set mouse mode to all modes
vim.opt.history = 1000 -- store the last 1000 commands entered

-- search
vim.opt.ignorecase = true -- case insensitive searching
vim.opt.smartcase = true -- case-sensitive if expresson contains a capital letter
vim.opt.hlsearch = true -- highlight search results
vim.opt.incsearch = true -- set incremental search, like modern browsers
vim.opt.lazyredraw = false -- don't redraw while executing macros
vim.opt.magic = true -- set magic on, for regular expressions

-- error bells
vim.opt.errorbells = false
vim.opt.visualbell = true
vim.opt.timeoutlen = 500

-- appearance
vim.o.termguicolors = true
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- show relative numbers
vim.opt.cursorline = true -- bullseye
vim.opt.cursorcolumn = true -- bullseye
vim.opt.wrap = true -- turn on line wrapping
vim.opt.wrapmargin = 8 -- wrap lines when coming within n characters from side
vim.opt.linebreak = true -- set soft wrapping
vim.opt.autoindent = true -- automatically set indent of new line
vim.opt.ttyfast = true -- faster redrawing
vim.opt.textwidth = 80 -- after configured number of characters, wrap line

vim.opt.laststatus = 3 -- show the global statusline all the time
vim.opt.scrolloff = 7 -- set 7 lines to the cursors - when moving vertical
vim.opt.wildmenu = true -- enhanced command line completion
vim.opt.hidden = true -- current buffer can be put into background
vim.opt.showcmd = true -- show incomplete commands
vim.opt.showmode = true -- don't show which mode disabled for PowerLine
vim.opt.wildmode = { "list", "longest" } -- complete files like a shell
vim.opt.shell = env.SHELL
vim.opt.cmdheight = 1 -- command bar height
vim.opt.title = true -- set terminal title
vim.opt.showmatch = true -- show matching braces
vim.opt.mat = 2 -- how many tenths of a second to blink
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.shortmess = "atToOFc" -- prompt message options

-- toggle invisible characters
vim.opt.showbreak = "↪"
vim.opt.fcs = "eob: " -- hide the ~ character on empty lines at the end of the buffer
vim.opt.list = true
vim.opt.listchars = {
    tab = "→ ",
    eol = "¬",
    trail = "⋅",
    extends = "❯",
    precedes = "❮",
}

-- code folding settings
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 99
opt.foldnestmax = 10 -- deepest fold is 10 levels
opt.foldenable = false -- don't fold by default
opt.foldlevel = 1

if vim.fn.has("nvim-0.9.0") == 1 then
    vim.opt.splitkeep = "screen"
    vim.o.shortmess = "filnxtToOFWIcC"
end

-- fix markdown indentation settings
vim.g.markdown_recommended_style = 0

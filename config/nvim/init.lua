-- init.lua
-- Neovim-specific configuration

require("globals")
local opt = vim.opt
local cmd = vim.cmd
local autocmd = vim.api.nvim_create_autocmd
local g = vim.g
local o = vim.o
local fn = vim.fn
local env = vim.env
local lsp = vim.lsp
local diagnostic = vim.diagnostic
local utils = require("utils")
local termcodes = utils.termcodes
local nmap = utils.nmap
local vmap = utils.vmap
local imap = utils.imap
local xmap = utils.xmap
local omap = utils.omap
local nnoremap = utils.nnoremap
local inoremap = utils.inoremap
local vnoremap = utils.vnoremap
local colors = require("theme").colors

-- create a completion_nvim table on _G which is visible via
-- v:lua from vimscript
_G.completion_nvim = {}

function _G.completion_nvim.smart_pumvisible(vis_seq, not_vis_seq)
    if fn.pumvisible() == 1 then
        return termcodes(vis_seq)
    else
        return termcodes(not_vis_seq)
    end
end

-- General
----------------------------------------------------------------
-- emmet invocation
g.user_emmet_leader_key = "<C-Z>"

-- in millisecond, used for both CursorHold and CursorHoldI,
-- use updatetime instead if not defined
-- used with plugin "antoinemadec/FixCursorHold.nvim"
g.cursorhold_updatetime = 100

cmd([[abbr funciton function]])
cmd([[abbr teh the]])
cmd([[abbr tempalte template]])
cmd([[abbr fitler filter]])
cmd([[abbr cosnt const]])
cmd([[abbr attribtue attribute]])
cmd([[abbr attribuet attribute]])

opt.backup = false -- don't use backup files
opt.writebackup = false -- don't backup the file while editing
opt.swapfile = false -- don't create swap files for new buffers
opt.updatecount = 0 -- don't write swap files after some number of updates

opt.backupdir = {
    "~/.vim-tmp",
    "~/.tmp",
    "~/tmp",
    "/var/tmp",
    "/tmp",
}

opt.directory = {
    "~/.vim-tmp",
    "~/.tmp",
    "~/tmp",
    "/var/tmp",
    "/tmp",
}

opt.history = 1000 -- store the last 1000 commands entered
opt.textwidth = 120 -- after configured number of characters, wrap line

opt.inccommand = "nosplit" -- show the results of substition as they're happening
-- but don't open a split

opt.backspace = { "indent", "eol,start" } -- make backspace behave in a sane manner
opt.clipboard = { "unnamed", "unnamedplus" } -- use the system clipboard
opt.mouse = "a" -- set mouse mode to all modes

-- searching
opt.ignorecase = true -- case insensitive searching
opt.smartcase = true -- case-sensitive if expresson contains a capital letter
opt.hlsearch = true -- highlight search results
opt.incsearch = true -- set incremental search, like modern browsers
opt.lazyredraw = false -- don't redraw while executing macros
opt.magic = true -- set magic on, for regular expressions

if fn.executable("rg") then
    -- if ripgrep installed, use that as a grepper
    opt.grepprg = "rg --vimgrep --no-heading"
    opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- error bells
opt.errorbells = false
opt.visualbell = true
opt.timeoutlen = 500

-- Appearance
---------------------------------------------------------
o.termguicolors = true
opt.number = true -- show line numbers
opt.relativenumber = true -- show relative numbers
opt.cursorline = true -- bullseye
opt.cursorcolumn = true -- bullseye
opt.wrap = true -- turn on line wrapping
opt.wrapmargin = 8 -- wrap lines when coming within n characters from side
opt.linebreak = true -- set soft wrapping
opt.showbreak = "↪"
opt.autoindent = true -- automatically set indent of new line
opt.ttyfast = true -- faster redrawing
table.insert(opt.diffopt, "vertical")
table.insert(opt.diffopt, "iwhite")
table.insert(opt.diffopt, "internal")
table.insert(opt.diffopt, "algorithm:patience")
table.insert(opt.diffopt, "hiddenoff")
opt.laststatus = 3 -- show the global statusline all the time
opt.scrolloff = 7 -- set 7 lines to the cursors - when moving vertical
opt.wildmenu = true -- enhanced command line completion
opt.hidden = true -- current buffer can be put into background
opt.showcmd = true -- show incomplete commands
opt.showmode = true -- don't show which mode disabled for PowerLine
opt.wildmode = { "list", "longest" } -- complete files like a shell
opt.shell = env.SHELL
opt.cmdheight = 1 -- command bar height
opt.title = true -- set terminal title
opt.showmatch = true -- show matching braces
opt.mat = 2 -- how many tenths of a second to blink
opt.updatetime = 300
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.shortmess = "atToOFc" -- prompt message options

-- Tab control
opt.smarttab = true -- tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
opt.tabstop = 4 -- the visible width of tabs
opt.softtabstop = 4 -- edit as if the tabs are 4 characters wide
opt.shiftwidth = 4 -- number of spaces to use for indent and unindent
opt.shiftround = true -- round indent to a multiple of 'shiftwidth'

-- code folding settings
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 99
opt.foldnestmax = 10 -- deepest fold is 10 levels
opt.foldenable = false -- don't fold by default
opt.foldlevel = 1

-- toggle invisible characters
opt.list = true
opt.listchars = {
    tab = "→ ",
    eol = "¬",
    trail = "⋅",
    extends = "❯",
    precedes = "❮",
}

-- hide the ~ character on empty lines at the end of the buffer
opt.fcs = "eob: "

-- Mappings
g.mapleader = ","
opt.pastetoggle = "<leader>v"

-- source current file
-- not working will need to tweak
nnoremap("<leader>sf", ":so %<CR>")

-- make current file executable
nnoremap("<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- source vimrc
nnoremap("<leader>sv", ":source $MYVIMRC<CR>")

-- unsets last search pattern register
nnoremap("<CR>", ":noh<CR>")

nmap("<leader>,", ":w<CR>")
nmap("<space>", ":set hlsearch! hlsearch?<CR>")

nmap("<leader><space>", [[:%s/\s\+$<CR>]])
nmap("<leader><space><space>", [[:%s/\n\{2,}/\r\r/g<CR>]])

nmap("<leader>l", ":set list!<CR>")
vmap("<", "<gv")
vmap(">", ">gv")
nmap("<leader>.", "<c-^>")
vmap(".", ":normal .<CR>")

-- helpers for dealing with other people's code
nmap([[\t]], ":set ts=4 sts=4 sw=4 noet<CR>")
nmap([[\s]], ":set ts=4 sts=4 sw=4 et<CR>")

-- move line mappings
local opt_h = "˙"
local opt_j = "∆"
local opt_k = "˚"
local opt_l = "¬"

nnoremap(opt_h, ":cprev<CR>zz")
nnoremap(opt_l, ":cnext<CR>zz")

nnoremap(opt_j, ":m .+1<CR>==")
nnoremap(opt_k, ":m .-2<CR>==")
inoremap(opt_j, "<Esc>:m .+1<CR>==gi")
inoremap(opt_k, "<Esc>:m .-2<CR>==gi")
-- vnoremap(opt_j, ":m '>+1<CR>gv=gv")
-- vnoremap(opt_k, ":m '<-2<CR>gv=gv")
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

-- custom text objects
-- inner-line
xmap("il", ":<c-u>normal! g_v^<CR>")
omap("il", ":<c-u>normal! g_v^<CR>")
-- around line
vmap("al", ":<c-u>normal! $v0<CR>")
omap("al", ":<c-u>normal! $v0<CR>")

require("plugins")

if utils.file_exists(fn.expand("~/.vimrc_background")) then
    g.base16colorspace = 256
    cmd([[source ~/.vimrc_background]])
end

-- plugin hotkeys
-- harpoon
nnoremap("<C-e>", ":lua require('harpoon.mark').add_file()<CR>")
nnoremap("<C-t>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
nnoremap("<C-h>", ":lua require('harpoon.ui').nav_file(1)<CR>")
nnoremap("<C-j>", ":lua require('harpoon.ui').nav_file(2)<CR>")
nnoremap("<C-k>", ":lua require('harpoon.ui').nav_file(3)<CR>")
nnoremap("<C-l>", ":lua require('harpoon.ui').nav_file(4)<CR>")

-- prettier
nnoremap("<leader>p", ":Prettier<CR>");

-- goto-preview go-to-preview gotopreview
nnoremap("gpd", ":lua require('goto-preview').goto_preview_definition()<CR>")
nnoremap("gpt", ":lua require('goto-preview').goto_preview_type_definition()<CR>")
nnoremap("gpi", ":lua require('goto-preview').goto_preview_implementation()<CR>")
nnoremap("gq", ":lua require('goto-preview').close_all_win()<CR>")
-- Only set if you have telescope installed
nnoremap("gpr", ":lua require('goto-preview').goto_preview_references()<CR>")

-- trouble keymappings
nnoremap("<leader>xx", ":TroubleToggle<CR>")
nnoremap("<leader>xw", ":TroubleToggle workspace_diagnostics<CR>")
nnoremap("<leader>xd", ":TroubleToggle document_diagnostics<CR>")
nnoremap("<leader>xq", ":TroubleToggle quickfix<CR>")
nnoremap("<leader>xl", ":TroubleToggle loclist<CR>")

-- lsp-format
cmd([[cabbrev wq execute "Format sync" <bar> wq]])
-- toggle diagnostic window with keypress
-- nnoremap("<leader>ge", ":lua vim.diagnostic.open_float(nil, {focus=false, scope='line'})<CR>")

-- fugitive
nmap("<leader>gb", ":G blame<CR>")
local function showFugitiveGit()
    if vim.fn.FugitiveHead() ~= '' then
        cmd([[
    Git
    " wincmd H  " Open Git window in vertical split
    " setlocal winfixwidth
    " vertical resize 31
    " setlocal winfixwidth
    setlocal nonumber
    setlocal norelativenumber
    ]]   )
    end
end

local function toggleFugitiveGit()
    if vim.fn.buflisted(vim.fn.bufname('fugitive:///*/.git//$')) ~= 0 then
        cmd([[ execute ":bdelete" bufname('fugitive:///*/.git//$') ]])
    else
        showFugitiveGit()
    end
end

-- toggle fugitive
vim.keymap.set('n', 'GF', toggleFugitiveGit)

-- todo-comment
nnoremap("<leader>fT", ":TodoTelescope<CR>")
nnoremap("<leader>xT", ":TodoTrouble<CR>")
-- next todo
vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
-- previous todo
vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- neotest
nnoremap("<leader>tr", ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>")
nnoremap("<leader>ts", ":lua require('neotest').run.run({ suite = true, adapter = adapter_id })<CR>")
nnoremap("<leader>tw", ":lua require('neotest').watch.watch()<CR>")
nnoremap("<leader>tx", ":lua require('neotest').run.stop()<CR>")
nnoremap("<leader>tn", ":lua require('neotest').run.run<CR>")
nnoremap("<leader>td", ":lua require('neotest').run.run({ strategy = 'dap' })<CR>")
nnoremap("<leader>tl", ":lua require('neotest').run.run_last<CR>")
nnoremap("<leader>tD", ":lua require('neotest').run.run_last({ strategy = 'dap' })<CR>")
nnoremap("<leader>ta", ":lua require('neotest').run.attach<CR>")
nnoremap("<leader>to", ":lua require('neotest').output.open({ enter = true })<CR>")
nnoremap("<leader>tO", ":lua require('neotest').output.open({ enter = true, short = true })<CR>")
nnoremap("<leader>tp", ":lua require('neotest').summary.toggle.run<CR>")
nnoremap("<leader>tm", ":lua require('neotest').summary.run_marked<CR>")
nnoremap("<leader>[t", ":lua require('neotest').jump.prev({status = 'failed'})<CR>")
nnoremap("<leader>]t", ":lua require('neotest').jump.next({status = 'failed'})<CR>")

-- whimsy
-- cellular automation
nmap("<leader>fml", ":CellularAutomaton make_it_rain<CR>")

-- spell checker cramping my LSP action
-- cmp-spell
-- opt.spell = true
-- opt.spelllang = { "en_us" }

cmd([[syntax on]])
cmd([[filetype plugin indent on]])

-- prettier formatting
-- formatting in normal mode
-- nmap("<leader>p", ":Prettier<CR>")

-- range_formatting in visual mode
-- xmap("<leader>p", ":Prettier<CR>")

-- tree sitter
-- issue when folds aren't found when using packer
-- vim.opt.foldmethod     = 'expr'
-- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
-- -WORKAROUND
autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("TS_FOLD_WORKAROUND", {}),
    callback = function()
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
})
---ENDWORKAROUND

-- theme selection
cmd("colorscheme tokyonight")
-- cmd("colorscheme hipster")
-- make the highlighting of tabs and other non-text less annoying
-- cmd([[highlight SpecialKey ctermfg=19 guifg=#f6f5fb]])
-- cmd([[highlight NonText ctermfg=19 guifg=#f6f5fb]])
-- floating window colors
-- cmd([[highlight Pmenu guibg=#0f4ac6 gui=NONE]])
-- cmd([[highlight PmenuSel guibg=#1997c6 gui=NONE]])
-- cmd([[highlight PmenuSbar guibg=#4e7cbf]])
-- cmd([[highlight PmenuThumb guibg=#f6f5fb]])
-- lsp doc colors
-- cmd([[highlight NormalFloat guibg=#0f4ac6]])
-- cmd([[highlight FloatBorder guifg=white guibg=#f6f5fb]])

-- lang language specifics
-- go golang go-lang specifics
local ONE_SECOND = 1000
local OrgImports = function()
    local params = lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = lsp.buf_request_sync(0, "textDocument/codeAction", params, ONE_SECOND)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                lsp.util.apply_workspace_edit(r.edit, "UTF-8")
            else
                lsp.buf.execute_command(r.command)
            end
        end
    end
end

autocmd({ "BufWritePre" }, {
    pattern = { "*.go" },
    callback = OrgImports,
})

-- rust
-- Enable type inlay hints
local InlayHints = function()
    require("lsp_extensions").inlay_hints({
        prefix = "",
        highlight = "Comment",
        enabled = { "TypeHint", "ChainingHint", "ParameterHint" },
    })
end

-- cmd([[ autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * :lua require'lsp_extensions'.inlay_hints{ prefix = '=>', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} } ]])
-- autocmd({ "CursorMoved", "InsertLeave", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost" }, {
--     pattern = {"*.rs"},
--     callback = InlayHints,
-- })

-- make comments and HTML attributes italic
cmd([[highlight Comment cterm=italic term=italic gui=italic]])
cmd([[highlight htmlArg cterm=italic term=italic gui=italic]])
cmd([[highlight xmlAttrib cterm=italic term=italic gui=italic]])
-- highlight Type cterm=italic term=italic gui=italic
cmd([[highlight Normal ctermbg=none]])
-- make the StatusLine background match the GalaxyLine styles
cmd("hi StatusLine guibg=" .. colors.bg)

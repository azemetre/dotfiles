local g = vim.g
local fn = vim.fn
local utils = require("utils")
local nmap = utils.nmap
local env = vim.env

local plugLoad = fn["functions#PlugLoad"]
local plugBegin = fn["plug#begin"]
local plugEnd = fn["plug#end"]
local Plug = fn["plug#"]

plugLoad()
plugBegin("~/.config/nvim/plugged")

-- a set of lua helpers that are used by other plugins
Plug("nvim-lua/plenary.nvim")

-- create themes
Plug("rktjmp/lush.nvim")

-- themes
Plug("azemetre/hipster.nvim")
Plug("folke/tokyonight.nvim", { ["branch"] = "main" })

-- easy commenting
Plug("tpope/vim-commentary")
Plug("JoosepAlviste/nvim-ts-context-commentstring")

-- mappings to easily delete, change and add such surroundings in pairs, such as quotes, parens, etc.
Plug("tpope/vim-surround")

-- endings for html, xml, etc. - ehances surround
Plug("tpope/vim-ragtag")

-- enables repeating other supported plugins with the . command
Plug("tpope/vim-repeat")

-- detect indent style (tabs vs. spaces)
Plug("tpope/vim-sleuth")

-- handy bracket mappings
Plug("tpope/vim-unimpaired")

-- notate interesting words, pretty neat!
Plug("lfv89/vim-interestingwords")

-- setup editorconfig
Plug("gpanders/editorconfig.nvim")

-- fugitive
Plug("tpope/vim-fugitive")
nmap("<leader>gb", ":G blame<cr>")

-- starts a html page to view markdown - can make changes live
Plug("iamcco/markdown-preview.nvim", { ["do"] = "cd app && yarn install" })

-- create ascii diagrams
Plug("jbyuki/venn.nvim")

-- general plugins
-- emmet support for vim - easily create markdup wth CSS-like syntax
Plug("mattn/emmet-vim")

-- match tags in html, similar to paren support
Plug("gregsexton/MatchTag", { ["for"] = "html" })

-- html5 support
Plug("othree/html5.vim", { ["for"] = "html" })

Plug("wavded/vim-stylus", { ["for"] = { "stylus", "markdown" } })
Plug("hail2u/vim-css3-syntax", { ["for"] = "css" })
Plug("cakebaker/scss-syntax.vim", { ["for"] = "scss" })
Plug("stephenway/postcss.vim", { ["for"] = "css" })

-- add color highlighting to hex values
Plug("norcalli/nvim-colorizer.lua")

-- use devicons for filetypes
Plug("kyazdani42/nvim-web-devicons")

-- indention guides for all lines
Plug("lukas-reineke/indent-blankline.nvim")

-- fast lau file drawer
Plug("kyazdani42/nvim-tree.lua")

-- Show git information in the gutter
Plug("lewis6991/gitsigns.nvim")

-- Helpers to configure the built-in Neovim LSP client
Plug("neovim/nvim-lspconfig")

-- Helpers to install LSPs and maintain them
Plug("williamboman/nvim-lsp-installer")

-- formatter for lsps
Plug("lukas-reineke/lsp-format.nvim")

-- snippet support
Plug("hrsh7th/vim-vsnip")
Plug("hrsh7th/vim-vsnip-integ")
Plug("rafamadriz/friendly-snippets")

-- neovim completion
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-nvim-lua")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/nvim-cmp")
-- spell checker
Plug("f3fora/cmp-spell")

-- used for rust inlay hints
Plug("nvim-lua/lsp_extensions.nvim")

-- preview native LSP's goto definition, type definition, implementation, and references in floating windows
Plug("rmagatti/goto-preview")

-- treesitter enables an AST-like understanding of files
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
-- show treesitter nodes
Plug("nvim-treesitter/playground")
-- enable more advanced treesitter-aware text objects
Plug("nvim-treesitter/nvim-treesitter-textobjects")
-- add rainbow highlighting to parens and brackets
Plug("p00f/nvim-ts-rainbow")

-- show nerd font icons for LSP types in completion menu
Plug("onsails/lspkind-nvim")

-- base16 syntax themes that are neovim/treesitter-aware
Plug("RRethy/nvim-base16")

-- status line plugin
Plug("feline-nvim/feline.nvim")

-- automatically complete brackets/parens/quotes
Plug("windwp/nvim-autopairs")

-- Run prettier and other formatters on save
-- Plug("mhartington/formatter.nvim")

-- Style the tabline without taking over how tabs and buffers work in Neovim
Plug("alvarosevilla95/luatab.nvim")

-- improve the default neovim interfaces, such as refactoring
Plug("stevearc/dressing.nvim")

-- when you only need to jump between a handful of files
Plug("ThePrimeagen/harpoon")

-- worktrees made easy
Plug("ThePrimeagen/git-worktree.nvim")

-- Navigate a code base with a really slick UI
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-telescope/telescope-rg.nvim")
Plug("nvim-telescope/telescope-file-browser.nvim")

-- Startup screen for Neovim
Plug("startup-nvim/startup.nvim")

-- fzf
Plug("/usr/local/bin/fzf")
Plug("junegunn/fzf.vim")
-- Power telescope with FZF
Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })

-- debug adapter protocol
Plug("mfussenegger/nvim-dap")
Plug("rcarriga/nvim-dap-ui")
Plug("theHamsta/nvim-dap-virtual-text")

Plug("folke/trouble.nvim")

plugEnd()

-- Once the plugins have been loaded, Lua-based plugins need to be required and started up
-- For plugins with their own configuration file, that file is loaded and is responsible for
-- starting them. Otherwise, the plugin itself is required and its `setup` method is called.
require("nvim-autopairs").setup()
require("colorizer")
require("plugins.git-worktree")
require("plugins.telescope")
require("plugins.gitsigns")
require("plugins.trouble")
require("plugins.fzf")
-- require("plugins.formatter")
require("plugins.lspconfig")
require("lsp-format")
require("plugins.completion")
require("plugins.treesitter")
require("plugins.goto-preview")
require("plugins.nvimtree")
require("plugins.tabline")
require("plugins.indent-blankline")
require("plugins.feline")

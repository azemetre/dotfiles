local g = vim.g
local fn = vim.fn
local cmd = vim.cmd
-- local utils = require("utils")
-- local nmap = utils.nmap
local env = vim.env

local ensure_packer = function()
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    -- core utils
    -- plugin manager
    use("wbthomason/packer.nvim")
    -- lsp
    use({
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.lspconfig")
        end,
    })
    -- fzf
    -- packer unable to install fzf
    -- use("/usr/local/bin/fzf")
    use("junegunn/fzf.vim")
    -- TODO NEED TO SETUP DAP
    -- dap - debugging
    use("mfussenegger/nvim-dap")
    use({
        "rcarriga/nvim-dap-ui",
        requires = {
            "mfussenegger/nvim-dap",
        },
    })
    use({
        "theHamsta/nvim-dap-virtual-text",
        requires = {
            "mfussenegger/nvim-dap",
        },
    })

    -- looks
    -- theme
    use({
        "azemetre/hipster.nvim",
        requires = { "rktjmp/lush.nvim" },
    })
    use("folke/tokyonight.nvim")
    -- build base16 color schemes
    use("RRethy/nvim-base16")
    -- indention guides for all lines
    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("plugins.indent-blankline")
        end,
    })
    -- status lines
    use({
        "feline-nvim/feline.nvim",
        config = function()
            require("plugins.feline")
        end,
    })
    -- pretty list of diagnostics
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("plugins.trouble")
        end,
    })

    -- comment tooling
    use("tpope/vim-commentary")
    use("JoosepAlviste/nvim-ts-context-commentstring")

    -- autogenerate code doc comments based on signature
    use({
        "danymat/neogen",
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("plugins.neogen")
        end,
        -- stable releases only
        tag = "*",
    })

    -- live preview of markdown files (includes mermaid)
    use({
        "iamcco/markdown-preview.nvim",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
    })

    -- create ascii diagrams
    use("jbyuki/venn.nvim")

    -- easily delete, change & add such surroundings in pairs, such as quotes,
    -- parens, etc.
    use("tpope/vim-surround")

    -- endings for html, xml, etc. - ehances surround
    use("tpope/vim-ragtag")

    -- enables repeating other supported plugins with the . command
    use("tpope/vim-repeat")

    -- detect indent style (tabs vs. spaces)
    use("tpope/vim-sleuth")

    -- not really using
    -- handy bracket mappings
    -- use("tpope/vim-unimpaired")

    -- setup editorconfig
    use("gpanders/editorconfig.nvim")

    -- languages
    -- misc
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("plugins.nvim-autopairs")
        end,
    })
    -- syntax
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        config = function()
            require("plugins.treesitter")
        end,
    })
    -- show treesitter nodes
    use("nvim-treesitter/playground")
    -- enable more advanced treesitter-aware text objects
    use("nvim-treesitter/nvim-treesitter-textobjects")
    -- current function context
    use("nvim-treesitter/nvim-treesitter-context")
    -- add rainbow highlighting to parens and brackets
    use("p00f/nvim-ts-rainbow")
    -- web dev
    use("mattn/emmet-vim")
    -- rust
    use({
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("plugins.crates")
        end,
    })
    use({
        "simrat39/rust-tools.nvim",
        requires = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("plugins.rust-tools")
        end,
    })

    -- lsp
    -- lsp tooling
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("plugins.null-ls")
        end,
    })
    use("williamboman/nvim-lsp-installer")
    use({
        "lukas-reineke/lsp-format.nvim",
    })

    -- lsp plugins
    use({
        "MunifTanjim/prettier.nvim",
        config = function()
            require("plugins.prettier")
        end,
    })

    -- navigation
    -- tree explorer
    use({
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons",
        },
        config = function()
            require("plugins.nvimtree")
        end,
    })
    -- fuzzy finder
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.0",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            "kyazdani42/nvim-web-devicons",
        },
        config = function()
            require("plugins.telescope")
        end,
    })
    -- enables fzf
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
    })
    -- harpoon
    use({
        "ThePrimeagen/harpoon",
        requires = {
            "nvim-lua/plenary.nvim",
        },
    })
    -- exploring
    use({
        "rmagatti/goto-preview",
        config = function()
            require("plugins.goto-preview")
        end,
    })

    -- improve the default neovim interfaces, such as refactoring or previews
    use("stevearc/dressing.nvim")

    -- testing
    use({
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- Fixes performance issue when using autocmd with CursorHold and
            -- CursorHoldI
            "antoinemadec/FixCursorHold.nvim",
        },
        config = function()
            require("plugins.neotest")
        end,
    })
    -- neotest plugins
    use("vim-test/vim-test")
    use("nvim-neotest/neotest-vim-test")
    use("nvim-neotest/neotest-go")

    -- snippets
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-vsnip",
        },
        config = function()
            require("plugins.completion")
        end,
    })
    use("hrsh7th/vim-vsnip-integ")
    use("hrsh7th/vim-vsnip")
    use({
        "L3MON4D3/LuaSnip",
        tag = "v<CurrentMajor>.*",
    })
    -- show nerd font icons for LSP types in completion menu
    use("onsails/lspkind-nvim")

    -- git
    -- fugitive
    use("tpope/vim-fugitive")

    use({
        "ThePrimeagen/git-worktree.nvim",
        config = function()
            require("plugins.git-worktree")
        end,
    })
    use({
        "lewis6991/gitsigns.nvim",
        config = function()
            require("plugins.gitsigns")
        end,
    })

    -- fun
    use({
        "eandrju/cellular-automaton.nvim",
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)

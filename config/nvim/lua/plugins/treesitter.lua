require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        -- "css", -- possible trojan installed, refer to \
        -- https://github.com/tree-sitter/tree-sitter-css/issues/35
        "dockerfile",
        "go",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "kotlin",
        "lua",
        "php",
        "prisma",
        "python",
        "rust",
        "typescript",
        "vim",
    },
    highlight = {
        enable = true,
        use_languagetree = true,
    },
    context_commentstring = {
        enable = true,
    },
    indent = { enable = true },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 1000,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- automatically jump forward to matching textobj
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
        keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
        },
    },
})

require('treesitter-context').setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    throttle = true, -- Throttles plugin updates (may improve performance)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    show_all_context = true,
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            "function",
            "method",
            "for",
            "while",
            "if",
            "switch",
            "case",
        },

        rust = {
            "loop_expression",
            "impl_item",
        },

        typescript = {
            "class_declaration",
            "abstract_class_declaration",
            "else_clause",
        },
    },
}

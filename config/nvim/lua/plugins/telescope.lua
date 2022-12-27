local telescope = require("telescope")
local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")
local nnoremap = require("utils").nnoremap

-- files to ignore with `file_ignore_patterns`
local always_ignore_these = {
    "yarn.lock", -- nodejs
    "package%-lock.json", -- nodejs
    "node_modules/.*", -- nodejs
    "vendor/*", -- golang
    "%.git/.*",
    "%.png",
    "%.jpeg",
    "%.jpg",
    "%.ico",
    "%.webp",
    "%.avif",
    "%.heic",
    "%.mp3",
    "%.mp4",
    "%.mkv",
    "%.mov",
    "%.wav",
    "%.flv",
    "%.avi",
    "%.webm",
    "%.db",
}

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<Esc>"] = actions.close, -- don't go into normal mode, just close
                ["<C-j>"] = actions.move_selection_next, -- scroll the list with <c-j>
                ["<C-k>"] = actions.move_selection_previous, -- scroll the list with <c-k>
                -- ["<C-\\->"] = actions.select_horizontal, -- open selection in new horizantal split
                -- ["<C-\\|>"] = actions.select_vertical, -- open selection in new vertical split
                ["<C-t>"] = trouble.open_with_trouble, -- open selection in new tab
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
            },
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim",
        },
        layout_strategy = "flex",
        layout_config = {
            prompt_position = "top",
            horizontal = {
                mirror = true,
                preview_cutoff = 100,
                preview_width = 0.5,
            },
            vertical = {
                mirror = true,
                preview_cutoff = 0.4,
            },
            flex = {
                flip_columns = 110,
            },
            height = 0.94,
            width = 0.86,
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = always_ignore_these,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    },
    pickers = {
        find_files = {
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
            hidden = true,
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
})

telescope.load_extension("fzf")
telescope.load_extension("file_browser")

-- mappings
nnoremap("<leader>ff", "<cmd>Telescope find_files<cr>")
nnoremap("<leader>fo", "<cmd>Telescope oldfiles<cr>")
nnoremap("<leader>fn", "<cmd>Telescope node_modules list<cr>")
nnoremap("<leader>fg", "<cmd>Telescope live_grep<cr>")
nnoremap("<leader>fr", "<cmd>lua require('telescope').extensions.live_grep_raw.live_grep_raw()<cr>")
nnoremap("<leader>fb", "<cmd>Telescope buffers<cr>")
nnoremap("<leader>ft", "<cmd>Telescope file_browser<cr>")
nnoremap("<leader>fh", "<cmd>Telescope help_tags<cr>")
nnoremap("<leader>gw", function()
    require("telescope").extensions.git_worktree.git_worktrees()
end)
nnoremap("<leader>gm", function()
    require("telescope").extensions.git_worktree.create_git_worktree()
end)

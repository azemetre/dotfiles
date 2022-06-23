local telescope = require("telescope")
local actions = require("telescope.actions")
local nnoremap = require("utils").nnoremap

telescope.setup(
  {
    defaults = {
      mappings = {
        i = {
          ["<Esc>"] = actions.close, -- don't go into normal mode, just close
          ["<C-j>"] = actions.move_selection_next, -- scroll the list with <c-j>
          ["<C-k>"] = actions.move_selection_previous, -- scroll the list with <c-k>
          -- ["<C-\\->"] = actions.select_horizontal, -- open selection in new horizantal split
          -- ["<C-\\|>"] = actions.select_vertical, -- open selection in new vertical split
          ["<C-t>"] = actions.select_tab, -- open selection in new tab
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down
        }
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim"
      },
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = {"node_modules"},
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      path_display = {"truncate"},
      winblend = 0,
      border = {},
      borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
      color_devicons = true,
      use_less = true,
      set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker
    },
    pickers = {
      find_files = {
        find_command = {"fd", "--type", "f", "--strip-cwd-prefix"}
      }
    },
    extensions = {
    }
  }
)


-- mappings
nnoremap("<leader>ff", "<cmd>Telescope find_files<cr>")
nnoremap("<leader>fo", "<cmd>Telescope oldfiles<cr>")
nnoremap("<leader>fn", "<cmd>Telescope node_modules list<cr>")
nnoremap("<leader>fg", "<cmd>Telescope live_grep<cr>")
nnoremap("<leader>fr", "<cmd>lua require('telescope').extensions.live_grep_raw.live_grep_raw()<cr>")
nnoremap("<leader>fb", "<cmd>Telescope buffers<cr>")
nnoremap("<leader>fh", "<cmd>Telescope help_tags<cr>")

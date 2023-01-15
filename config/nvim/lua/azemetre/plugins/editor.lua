local icons = require("azemetre.theme").icons

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

return {

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTree",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>et",
        "<cmd>NvimTreeToggle<CR>",
        desc = "NvimTree toggle",
      },
      { "<leader>ef", "<cmd>NvimTreeFocus<CR>", desc = "NvimTree focus" },
      { "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "NvimTree refresh" },
    },
    opts = {
      disable_netrw = false,
      hijack_netrw = true,
      diagnostics = {
        enable = false,
        icons = {
          hint = icons.hint,
          info = icons.info,
          warning = icons.warning,
          error = icons.error,
        },
      },
      renderer = {
        add_trailing = false,
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = "all",
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            default = icons.file,
            symlink = icons.symlink,
            git = {
              unstaged = icons.unmerged,
              staged = icons.staged,
              unmerged = icons.unmerged,
              renamed = icons.renamed,
              untracked = icons.untracked,
              deleted = icons.deleted,
              ignored = icons.ignored,
            },
            folder = {
              arrow_open = icons.arrow_open,
              arrow_closed = icons.arrow_closed,
              default = icons.default,
              open = icons.open,
              empty = icons.empty,
              empty_open = icons.empty_open,
              symlink = icons.symlink,
              symlink_open = icons.symlink_open,
            },
          },
        },
      },
      update_focused_file = {
        enable = true,
        update_cwd = false,
      },
      git = {
        enable = true,
        ignore = false,
      },
      view = {
        width = 40,
        side = "right",
        relativenumber = true,
      },
    },
  },

  -- search/replace in multiple files
  {
    "windwp/nvim-spectre",
        -- stylua: ignore
        keys = {
            { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
        },
  },

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    version = false, -- telescope did only one release, so use HEAD for now
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>" },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<c-t>"] = function(...)
              return require("trouble.providers.telescope").open_with_trouble(...)
            end,
            -- -- don't go into normal mode, just close
            -- ["<Esc>"] = require("telescope.actions").close,
            -- -- scroll the list with <c-j> and <c-k>
            -- ["<C-j>"] = require("telescope.actions"),
            -- ["<C-k>"] = require("telescope.actions").move_selection_previous,
            -- -- move the preview window up and down
            -- ["<C-u>"] = require("telescope.actions").preview_scrolling_up,
            -- ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
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
        -- file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = always_ignore_these,
        -- generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        -- file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        -- grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        -- qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        -- buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
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
    },
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  -- jump between 4 files
  {
    "ThePrimeagen/harpoon",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<C-e>", ":lua require('harpoon.mark').add_file()<CR>" },
      { "<C-t>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>" },
      { "<C-h>", ":lua require('harpoon.ui').nav_file(1)<CR>" },
      { "<C-j>", ":lua require('harpoon.ui').nav_file(2)<CR>" },
      { "<C-k>", ":lua require('harpoon.ui').nav_file(3)<CR>" },
      { "<C-l>", ":lua require('harpoon.ui').nav_file(4)<CR>" },
    },
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

                -- stylua: ignore start
                map("n", "]h", gs.prev_hunk, "Next Hunk")
                map("n", "[h", gs.next_hunk, "Prev Hunk")
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- references
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
        -- stylua: ignore
        keys = {
            { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
            { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
        },
  },

  {
    "rmagatti/goto-preview",
    opts = {
      -- Width of the floating window
      width = 120,
      -- Height of the floating window
      height = 15,
      -- Border characters of the floating window
      border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
      -- Bind default mappings
      default_mappings = false,
      -- Print debug information
      debug = false,
      -- 0-100 opacity level of the floating window where 100 is fully transparent.
      opacity = nil,
      -- Binds arrow keys to resizing the floating window.
      resizing_mappings = false,
      -- A function taking two arguments, a buffer and a window to be ran as a hook.
      post_open_hook = nil,
      -- Focus the floating window when opening it.
      focus_on_open = true,
      -- Dismiss the floating window when moving the cursor.
      dismiss_on_move = false,
      -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
      force_close = true,
      -- the bufhidden option to set on the floating window. See :h bufhidden
      bufhidden = "wipe",
    },
  },

  -- editorconfig
  {
    "editorconfig/editorconfig-vim",
    event = "BufReadPre",
  },

  -- buffer remove
  {
    "echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
            { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
        },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = true,
        -- stylua: ignore
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
            { "<leader>xtt", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo Trouble" },
            { "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
        },
  },
}

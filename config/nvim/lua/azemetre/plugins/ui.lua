return {
  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- feline -- statusline
  {
    "feline-nvim/feline.nvim",
    event = "VeryLazy",
    config = function()
      local theme = require("azemetre.theme")
      local colors = theme.colors
      local icons = theme.icons

      local vi_mode_colors = {
        NORMAL = colors.violet,
        INSERT = colors.aqua,
        VISUAL = colors.magenta,
        OP = colors.green,
        BLOCK = colors.blue,
        REPLACE = colors.violet,
        ["V-REPLACE"] = colors.darkorange,
        ENTER = colors.cyan,
        MORE = colors.cyan,
        SELECT = colors.orange,
        COMMAND = colors.green,
        SHELL = colors.green,
        TERM = colors.green,
        NONE = colors.yellow,
      }

      local function file_osinfo()
        local os = vim.bo.fileformat:upper()
        local icon
        if os == "UNIX" then
          icon = icons.linux
        elseif os == "MAC" then
          icon = icons.macos
        else
          icon = icons.windows
        end
        return icon .. os
      end

      local lsp = require("feline.providers.lsp")
      local vi_mode_utils = require("feline.providers.vi_mode")

      local lsp_get_diag = function(str)
        local diagnostics = vim.diagnostic.get(0, { severity = str })
        local count = #diagnostics
        return (count > 0) and " " .. count .. " " or ""
      end

      local comps = {
        vi_mode = {
          left = {
            provider = function()
              return " " .. icons.ghost .. " " .. vi_mode_utils.get_vim_mode()
            end,
            hl = function()
              local val = {
                name = vi_mode_utils.get_mode_highlight_name(),
                fg = vi_mode_utils.get_mode_color(),
                -- fg = colors.bg
              }
              return val
            end,
            right_sep = " ",
          },
          right = {
            -- provider = "▊",
            provider = "",
            hl = function()
              local val = {
                name = vi_mode_utils.get_mode_highlight_name(),
                fg = vi_mode_utils.get_mode_color(),
              }
              return val
            end,
            left_sep = " ",
            right_sep = " ",
          },
        },
        file = {
          info = {
            provider = {
              name = "file_info",
              opts = {
                type = "unique",
                file_readonly_icon = icons.file_readonly,
                file_modified_icon = icons.file_modified,
              },
            },
            hl = {
              fg = colors.blue,
              style = "bold",
            },
          },
          encoding = {
            provider = "file_encoding",
            left_sep = " ",
            hl = {
              fg = colors.violet,
              style = "bold",
            },
          },
          type = {
            provider = "file_type",
          },
          os = {
            provider = file_osinfo,
            left_sep = " ",
            hl = {
              fg = colors.violet,
              style = "bold",
            },
          },
          position = {
            provider = "position",
            left_sep = " ",
            hl = {
              fg = colors.cyan,
              -- style = 'bold'
            },
          },
        },
        left_end = {
          provider = function()
            return ""
          end,
          hl = {
            fg = colors.bg,
            bg = colors.blue,
          },
        },
        line_percentage = {
          provider = "line_percentage",
          left_sep = " ",
          hl = {
            style = "bold",
          },
        },
        scroll_bar = {
          provider = "scroll_bar",
          left_sep = " ",
          hl = {
            fg = colors.blue,
            style = "bold",
          },
        },
        diagnos = {
          err = {
            -- provider = 'diagnostic_errors',
            provider = function()
              return icons.error .. lsp_get_diag("Error")
            end,
            -- left_sep = ' ',
            enabled = function()
              return lsp.diagnostics_exist("Error")
            end,
            hl = {
              fg = colors.red,
            },
          },
          warn = {
            provider = function()
              return icons.warning .. lsp_get_diag("Warn")
            end,
            enabled = function()
              return lsp.diagnostics_exist("Warn")
            end,
            hl = {
              fg = colors.yellow,
            },
          },
          info = {
            provider = function()
              return icons.info .. lsp_get_diag("Info")
            end,
            enabled = function()
              return lsp.diagnostics_exist("Info")
            end,
            hl = {
              fg = colors.blue,
            },
          },
          hint = {
            provider = function()
              return icons.hint .. lsp_get_diag("Hint")
            end,
            enabled = function()
              return lsp.diagnostics_exist("Hint")
            end,
            hl = {
              fg = colors.cyan,
            },
          },
        },
        lsp = {
          name = {
            provider = "lsp_client_names",
            left_sep = " ",
            icon = icons.lsp .. " ",
            right_sep = " ",
            hl = {
              fg = colors.grey,
            },
          },
        },
        git = {
          branch = {
            provider = "git_branch",
            right_sep = " ",
            icon = icons.git .. " ",
            left_sep = " ",
            hl = {
              fg = colors.violet,
              style = "bold",
            },
          },
          add = {
            provider = "git_diff_added",
            hl = {
              fg = colors.green,
            },
          },
          change = {
            provider = "git_diff_changed",
            icon = " " .. icons.modified .. " ",
            hl = {
              fg = colors.yellow,
            },
          },
          remove = {
            provider = "git_diff_removed",
            hl = {
              fg = colors.red,
            },
          },
        },
      }

      local components = {
        active = {},
        inactive = {},
      }

      table.insert(components.active, {})
      table.insert(components.active, {})
      table.insert(components.active, {})
      table.insert(components.inactive, {})
      table.insert(components.inactive, {})
      table.insert(components.inactive, {})

      table.insert(components.active[1], comps.vi_mode.left)
      table.insert(components.active[1], comps.file.info)
      table.insert(components.active[1], comps.git.branch)
      table.insert(components.active[1], comps.git.add)
      table.insert(components.active[1], comps.git.change)
      table.insert(components.active[1], comps.git.remove)
      table.insert(components.inactive[1], comps.vi_mode.left)
      table.insert(components.inactive[1], comps.file.info)
      table.insert(components.active[3], comps.diagnos.err)
      table.insert(components.active[3], comps.diagnos.warn)
      table.insert(components.active[3], comps.diagnos.hint)
      table.insert(components.active[3], comps.diagnos.info)
      table.insert(components.active[3], comps.lsp.name)
      table.insert(components.active[3], comps.file.os)
      table.insert(components.active[3], comps.file.position)
      table.insert(components.active[3], comps.line_percentage)
      table.insert(components.active[3], comps.scroll_bar)
      table.insert(components.active[3], comps.vi_mode.right)

      require("feline").setup({
        theme = {
          bg = colors.bg,
          fg = colors.fg,
        },
        components = components,
        vi_mode_colors = vi_mode_colors,
        force_inactive = {
          filetypes = {
            "packer",
            "NvimTree",
            "fugitive",
            "fugitiveblame",
          },
          buftypes = { "terminal" },
          bufnames = {},
        },
      })
    end,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
      },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  -- active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "BufReadPre",
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require("mini.indentscope").setup(opts)
    end,
  },

  -- dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
                                                 :::
                                             :: :::.
                       \/,                    .:::::
           \),          \`-._                 :::888
           /\            \   `-.             ::88888
          /  \            | .(                ::88
         /,.  \           ; ( `              .:8888
            ), \         / ;``               :::888
           /_   \     __/_(_                  :88
             `. ,`..-'      `-._    \  /      :8
               )__ `.           `._ .\/.
              /   `. `             `-._______m         _,
  ,-=====-.-;'                 ,  ___________/ _,-_,'"`/__,-.
 C   =--   ;                   `.`._    V V V       -=-'"#==-._
:,  \     ,|      UuUu _,......__   `-.__A_A_ -. ._ ,--._ ",`` `-
||  |`---' :    uUuUu,'          `'--...____/   `" `".   `
|`  :       \   UuUu:
:  /         \   UuUu`-._
 \(_          `._  uUuUu `-.
 (_3             `._  uUu   `._
                    ``-._      `.
                         `-._    `.
                             `.    \
                               )   ;
                              /   /
               `.        |\ ,'   /
                 ",_A_/\-| `   ,'
                   `--..,_|_,-'\
                          |     \
                          |      \__
                          |__
      ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button(
          "f",
          " " .. " Find file",
          ":Telescope find_files <CR>"
        ),
        dashboard.button(
          "r",
          " " .. " Recent files",
          ":Telescope oldfiles <CR>"
        ),
        dashboard.button(
          "g",
          " " .. " Find text",
          ":Telescope live_grep <CR>"
        ),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button(
          "s",
          "勒" .. " Restore Session",
          [[:lua require("persistence").load() <cr>]]
        ),
        dashboard.button("l", "鈴" .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      vim.b.miniindentscope_disable = true

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded "
            .. stats.count
            .. " plugins in "
            .. ms
            .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- color picker and lsp
  {
    "uga-rosa/ccc.nvim",
    config = function()
      local ccc = require("ccc")
      local mapping = ccc.mapping
      local input = ccc.input
      local output = ccc.output
      local picker = ccc.picker

      ccc.setup({
        ---@type string hex
        default_color = "#000000",
        ---@type string
        bar_char = "■",
        ---@type string
        point_char = "◇",
        ---@type string hex
        point_color = "",
        ---@type integer
        bar_len = 30,
        ---@type table
        win_opts = {
          relative = "cursor",
          row = 1,
          col = 1,
          style = "minimal",
          border = "rounded",
        },
        ---@type boolean
        auto_close = true,
        ---@type boolean
        preserve = false,
        ---@type boolean
        save_on_quit = false,
        ---@type show_mode
        alpha_show = "auto",
        ---@type ColorInput[]
        inputs = {
          input.rgb,
          input.hsl,
          input.cmyk,
        },
        ---@type ColorOutput[]
        outputs = {
          output.hex,
          output.hex_short,
          output.css_rgb,
          output.css_hsl,
        },
        ---@type ColorPicker[]
        pickers = {
          picker.hex,
          picker.css_rgb,
          picker.css_hsl,
          picker.css_hwb,
          picker.css_lab,
          picker.css_lch,
          picker.css_oklab,
          picker.css_oklch,
        },
        ---@type table<string, string[] | string | nil>
        exclude_pattern = {
          hex = {
            "[%w_]{{pattern}}",
            "{{pattern}}[g-zG-Z_]",
          },
          css_rgb = nil,
          css_hsl = nil,
          css_hwb = nil,
          css_name = {
            "[%w_]{{pattern}}",
            "{{pattern}}[%w_]",
          },
        },
        ---@type hl_mode
        highlight_mode = "bg",
        ---@type function
        output_line = ccc.output_line,
        ---@type table
        highlighter = {
          ---@type boolean
          auto_enable = true,
          ---@type integer
          max_byte = 100 * 1024, -- 100 KB
          ---@type string[]
          filetypes = {},
          ---@type string[]
          excludes = {},
          ---@type boolean
          lsp = true,
        },
    -- stylua: ignore
    ---@type {[1]: ColorPicker, [2]: ColorOutput}[]
    convert = {
        { picker.hex, output.css_rgb },
        { picker.css_rgb, output.css_hsl },
        { picker.css_hsl, output.hex },
    },
        recognize = {
          input = false,
          output = false,
        -- stylua: ignore
        ---@alias RecognizePattern table<ColorPicker, {[1]: ColorInput, [2]: ColorOutput}>
        ---@type RecognizePattern
        pattern = {
            [picker.css_rgb]   = { input.rgb, output.rgb },
            [picker.css_name]  = { input.rgb, output.rgb },
            [picker.hex]       = { input.rgb, output.hex },
            [picker.css_hsl]   = { input.hsl, output.css_hsl },
            [picker.css_hwb]   = { input.hwb, output.css_hwb },
            [picker.css_lab]   = { input.lab, output.css_lab },
            [picker.css_lch]   = { input.lch, output.css_lch },
            [picker.css_oklab] = { input.oklab, output.css_oklab },
            [picker.css_oklch] = { input.oklch, output.css_oklch },
        },
        },
        ---@type table<string, function>
        mappings = {
          ["q"] = mapping.quit,
          ["<CR>"] = mapping.complete,
          ["i"] = mapping.toggle_input_mode,
          ["o"] = mapping.toggle_output_mode,
          ["a"] = mapping.toggle_alpha,
          ["g"] = mapping.toggle_prev_colors,
          ["w"] = mapping.goto_next,
          ["b"] = mapping.goto_prev,
          ["W"] = mapping.goto_tail,
          ["B"] = mapping.goto_head,
          ["l"] = mapping.increase1,
          ["d"] = mapping.increase5,
          [","] = mapping.increase10,
          ["h"] = mapping.decrease1,
          ["s"] = mapping.decrease5,
          ["m"] = mapping.decrease10,
          ["H"] = mapping.set0,
          ["M"] = mapping.set50,
          ["L"] = mapping.set100,
          ["0"] = mapping.set0,
          ["1"] = function()
            ccc.set_percent(10)
          end,
          ["2"] = function()
            ccc.set_percent(20)
          end,
          ["3"] = function()
            ccc.set_percent(30)
          end,
          ["4"] = function()
            ccc.set_percent(40)
          end,
          ["5"] = mapping.set50,
          ["6"] = function()
            ccc.set_percent(60)
          end,
          ["7"] = function()
            ccc.set_percent(70)
          end,
          ["8"] = function()
            ccc.set_percent(80)
          end,
          ["9"] = function()
            ccc.set_percent(90)
          end,
        },
      })
    end,
  },

  -- icons
  "nvim-tree/nvim-web-devicons",

  -- ui components
  "MunifTanjim/nui.nvim",
}

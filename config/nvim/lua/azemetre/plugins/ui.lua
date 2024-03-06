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
	-- feline-nvim/feline.nvim in archive mode
	-- freddiehaddad/feline.nvim is actively maintained
	{
		"freddiehaddad/feline.nvim",
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
							return " "
								.. icons.ghost
								.. " "
								.. vi_mode_utils.get_vim_mode()
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
						provider = function()
							local clients = vim.lsp.get_active_clients({ bufnr = 0 })
							if next(clients) == nil then
								return "No LSP"
							end

							local abbreviations = {
								lua_ls = "lua",
								rust_analyzer = "rust",
								["tsserver"] = "ts",
								emmet_language_server = "emmet",
								["awk-language-server"] = "awk",
								["ansible-language-server"] = "ansible",
								["bash-language-server"] = "bash",
								["bash-debug-adapter"] = "bash-dap",
								["chrome-debug-adapter"] = "chrome-dap",
								["css-lsp"] = "css",
								["dockerfile-language-server"] = "docker",
								["elixir-ls"] = "elixir",
								["emmet-language-server"] = "emmet",
								["eslint-lsp"] = "eslint",
								["firefox-debug-adapter"] = "firefox-dap",
								["go-debug-adapter"] = "go-dap",
								["gopls"] = "go",
								["html-lsp"] = "html",
								["htmx-lsp"] = "htmx",
								["json-lsp"] = "json",
								["ltex-ls"] = "ltex",
								["lua-language-server"] = "lua",
								["nginx-language-server"] = "nginx",
								["php-debug-adapter"] = "php-dap",
								["stylelint-lsp"] = "stylelint",
								["svelte-language-server"] = "svelte",
								["terraform-ls"] = "terraform",
								["vim-language-server"] = "vim",
								["yaml-language-server"] = "yaml",
							}

							local names = {}
							for _, client in ipairs(clients) do
								local name = abbreviations[client.name] or client.name
								table.insert(names, name)
							end
							return icons.lsp .. " " .. table.concat(names, " ")
						end,
						left_sep = " ",
						icon = "", -- We moved the icon to the provider function
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

	-- statusline - lualine
	-- {
	--   "nvim-lualine/lualine.nvim",
	--   event = "VeryLazy",
	--   opts = function(plugin)
	-- 	local lualine = require('lualine')
	--
	-- 	-- Color table for highlights
	-- 	-- stylua: ignore
	-- 	local colors = {
	-- 		bg       = '#202328',
	-- 		fg       = '#bbc2cf',
	-- 		yellow   = '#ECBE7B',
	-- 		cyan     = '#008080',
	-- 		darkblue = '#081633',
	-- 		green    = '#98be65',
	-- 		orange   = '#FF8800',
	-- 		violet   = '#a9a1e1',
	-- 		magenta  = '#c678dd',
	-- 		blue     = '#51afef',
	-- 		red      = '#ec5f67',
	-- 	}
	--
	-- 	local conditions = {
	-- 		buffer_not_empty = function()
	-- 			return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
	-- 		end,
	-- 		hide_in_width = function()
	-- 			return vim.fn.winwidth(0) > 80
	-- 		end,
	-- 		check_git_workspace = function()
	-- 			local filepath = vim.fn.expand('%:p:h')
	-- 			local gitdir = vim.fn.finddir('.git', filepath .. ';')
	-- 			return gitdir and #gitdir > 0 and #gitdir < #filepath
	-- 		end,
	-- 	}
	--
	-- 	-- Config
	-- 	local config = {
	-- 		options = {
	-- 			-- Disable sections and component separators
	-- 			component_separators = '',
	-- 			section_separators = '',
	-- 			theme = {
	-- 				-- We are going to use lualine_c an lualine_x as left and
	-- 				-- right section. Both are highlighted by c theme .  So we
	-- 				-- are just setting default looks o statusline
	-- 				normal = { c = { fg = colors.fg, bg = colors.bg } },
	-- 				inactive = { c = { fg = colors.fg, bg = colors.bg } },
	-- 			},
	-- 		},
	-- 		sections = {
	-- 			-- these are to remove the defaults
	-- 			lualine_a = {},
	-- 			lualine_b = {},
	-- 			lualine_y = {},
	-- 			lualine_z = {},
	-- 			-- These will be filled later
	-- 			lualine_c = {},
	-- 			lualine_x = {},
	-- 		},
	-- 		inactive_sections = {
	-- 			-- these are to remove the defaults
	-- 			lualine_a = {},
	-- 			lualine_b = {},
	-- 			lualine_y = {},
	-- 			lualine_z = {},
	-- 			lualine_c = {},
	-- 			lualine_x = {},
	-- 		},
	-- 	}
	--
	-- 	-- Inserts a component in lualine_c at left section
	-- 	local function ins_left(component)
	-- 		table.insert(config.sections.lualine_c, component)
	-- 	end
	--
	-- 	-- Inserts a component in lualine_x ot right section
	-- 	local function ins_right(component)
	-- 		table.insert(config.sections.lualine_x, component)
	-- 	end
	--
	-- 	ins_left {
	-- 		function()
	-- 			return '▊'
	-- 		end,
	-- 		color = { fg = colors.blue }, -- Sets highlighting of component
	-- 		padding = { left = 0, right = 1 }, -- We don't need space before this
	-- 	}
	--
	-- 	ins_left {
	-- 		-- mode component
	-- 		function()
	-- 			return ''
	-- 		end,
	-- 		color = function()
	-- 			-- auto change color according to neovims mode
	-- 			local mode_color = {
	-- 				n = colors.red,
	-- 				i = colors.green,
	-- 				v = colors.blue,
	-- 				[''] = colors.blue,
	-- 				V = colors.blue,
	-- 				c = colors.magenta,
	-- 				no = colors.red,
	-- 				s = colors.orange,
	-- 				S = colors.orange,
	-- 				[''] = colors.orange,
	-- 				ic = colors.yellow,
	-- 				R = colors.violet,
	-- 				Rv = colors.violet,
	-- 				cv = colors.red,
	-- 				ce = colors.red,
	-- 				r = colors.cyan,
	-- 				rm = colors.cyan,
	-- 				['r?'] = colors.cyan,
	-- 				['!'] = colors.red,
	-- 				t = colors.red,
	-- 			}
	-- 			return { fg = mode_color[vim.fn.mode()] }
	-- 		end,
	-- 		padding = { right = 1 },
	-- 	}
	--
	-- 	ins_left {
	-- 		-- filesize component
	-- 		'filesize',
	-- 		cond = conditions.buffer_not_empty,
	-- 	}
	--
	-- 	ins_left {
	-- 		'filename',
	-- 		cond = conditions.buffer_not_empty,
	-- 		color = { fg = colors.magenta, gui = 'bold' },
	-- 	}
	--
	-- 	ins_left { 'location' }
	--
	-- 	ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }
	--
	-- 	ins_left {
	-- 		'diagnostics',
	-- 		sources = { 'nvim_diagnostic' },
	-- 		symbols = { error = ' ', warn = ' ', info = ' ' },
	-- 		diagnostics_color = {
	-- 			color_error = { fg = colors.red },
	-- 			color_warn = { fg = colors.yellow },
	-- 			color_info = { fg = colors.cyan },
	-- 		},
	-- 	}
	--
	-- 	-- Insert mid section. You can make any number of sections in neovim :)
	-- 	-- for lualine it's any number greater then 2
	-- 	ins_left {
	-- 		function()
	-- 			return '%='
	-- 		end,
	-- 	}
	--
	-- 	ins_left {
	-- 		-- Lsp server name .
	-- 		function()
	-- 			local msg = 'No Active Lsp'
	-- 			local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
	-- 			local clients = vim.lsp.get_active_clients()
	-- 			if next(clients) == nil then
	-- 				return msg
	-- 			end
	-- 			for _, client in ipairs(clients) do
	-- 				local filetypes = client.config.filetypes
	-- 				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
	-- 					return client.name
	-- 				end
	-- 			end
	-- 			return msg
	-- 		end,
	-- 		icon = ' LSP:',
	-- 		color = { fg = '#ffffff', gui = 'bold' },
	-- 	}
	--
	-- 	-- Add components to right sections
	-- 	ins_right {
	-- 		'o:encoding', -- option component same as &encoding in viml
	-- 		fmt = string.upper, -- I'm not sure why it's upper case either ;)
	-- 		cond = conditions.hide_in_width,
	-- 		color = { fg = colors.green, gui = 'bold' },
	-- 	}
	--
	-- 	ins_right {
	-- 		'fileformat',
	-- 		fmt = string.upper,
	-- 		icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
	-- 		color = { fg = colors.green, gui = 'bold' },
	-- 	}
	--
	-- 	ins_right {
	-- 		'branch',
	-- 		icon = '',
	-- 		color = { fg = colors.violet, gui = 'bold' },
	-- 	}
	--
	-- 	ins_right {
	-- 		'diff',
	-- 		-- Is it me or the symbol for modified us really weird
	-- 		symbols = { added = ' ', modified = '柳 ', removed = ' ' },
	-- 		diff_color = {
	-- 			added = { fg = colors.green },
	-- 			modified = { fg = colors.orange },
	-- 			removed = { fg = colors.red },
	-- 		},
	-- 		cond = conditions.hide_in_width,
	-- 	}
	--
	-- 	ins_right {
	-- 		function()
	-- 			return '▊'
	-- 		end,
	-- 		color = { fg = colors.blue },
	-- 		padding = { left = 1 },
	-- 	}
	--   end,
	-- },

	-- indent guides for Neovim
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "BufReadPre",
		config = function()
			local ibl = require("ibl")
			ibl.setup({
				indent = {
					char = "|",
				},
				exclude = {
					filetypes = {
						"help",
						"alpha",
						"dashboard",
						"neo-tree",
						"lazy",
						"Trouble",
					},
				},
				whitespace = {
					remove_blankline_trail = false,
				},
				scope = {
					enabled = false,
				},
			})
		end,
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
			local neovim = {
				type = "text",
				val = {
					[[                                        ]],
					[[ ██████████████████████████████████████ ]],
					[[ █▄ ▀█▄ ▄█▄ ▄▄ █ ▄▄ █▄ █ ▄█▄ ▄█▄ ▀█▀ ▄█ ]],
					[[ ██ █▄▀ ███ ▄█▀█ ██ ██▄▀▄███ ███ █▄█ ██ ]],
					[[ ▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀▄▄▄▄▀▀▀▄▀▀▀▄▄▄▀▄▄▄▀▄▄▄▀ ]],
					[[                                        ]],
				},
				opts = {
					position = "center",
					type = "ascii",
					hl = "String",
				},
			}
			local trogdor = {
				type = "text",
				val = {
					[[                                                                 ]],
					[[                                                 :::             ]],
					[[                                             :: :::.             ]],
					[[                       \/,                    .:::::             ]],
					[[           \),          \`-._                 :::888             ]],
					[[           /\            \   `-.             ::88888             ]],
					[[          /  \            | .(                ::88               ]],
					[[         /,.  \           ; ( `              .:8888              ]],
					[[            ), \         / ;``               :::888              ]],
					[[           /_   \     __/_(_                  :88                ]],
					[[             `. ,`..-'      `-._    \  /      :8                 ]],
					[[               )__ `.           `._ .\/.                         ]],
					[[              /   `. `             `-._______m         _,        ]],
					[[  ,-=====-.-;'                 ,  ___________/ _,-_,'"`/__,-.    ]],
					[[ C   =--   ;                   `.`._    V V V       -=-'"#==-._  ]],
					[[:,  \     ,|      UuUu _,......__   `-.__A_A_ -. ._ ,--._ ",`` `-]],
					[[||  |`---' :    uUuUu,'          `'--...____/   `" `".   `       ]],
					[[|`  :       \   UuUu:                                            ]],
					[[:  /         \   UuUu`-._                                        ]],
					[[ \(_          `._  uUuUu `-.                                     ]],
					[[ (_3             `._  uUu   `._                                  ]],
					[[                    ``-._      `.                                ]],
					[[                         `-._    `.                              ]],
					[[                             `.    \                             ]],
					[[                               )   ;                             ]],
					[[                              /   /                              ]],
					[[               `.        |\ ,'   /                               ]],
					[[                 ",_A_/\-| `   ,'                                ]],
					[[                   `--..,_|_,-'\                                 ]],
					[[                          |     \                                ]],
					[[                          |      \__                             ]],
					[[                          |__                                    ]],
				},
				opts = {
					position = "center",
					type = "ascii",
					hl = "String",
				},
			}

			-- figure out a way to change font size for ascii art
			-- dashboard.section.header.val = trogdor.val
			dashboard.section.header.val = neovim.val
			dashboard.section.buttons.val = {
				dashboard.button(
					"f",
					" " .. " Find file",
					":Telescope find_files <CR>"
				),
				dashboard.button(
					"g",
					" " .. " Find text",
					":Telescope live_grep <CR>"
				),
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
		"NvChad/nvim-colorizer.lua",
		event = "VeryLazy",
		opts = {
			css = false,
			hsl_fn = true,
			rgb_fn = true,
			css_fn = true,
		},
		-- need to create a function that passes opts to the setup for nvim-colorizer
		-- but all follow the lazy.nvim guidelines
		config = function(_, opts)
			require("colorizer").setup(opts)
		end,
	},

	-- icons
	"nvim-tree/nvim-web-devicons",

	-- ui components
	"MunifTanjim/nui.nvim",
}

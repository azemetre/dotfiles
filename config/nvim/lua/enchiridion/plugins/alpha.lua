-- #dashboard #startup #ui
return {
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
			dashboard.button("f", " " .. " Find file", ":FzfLua files <CR>"),
			dashboard.button(
				"g",
				" " .. " Find text",
				":FzfLua live_grep <CR>"
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
}

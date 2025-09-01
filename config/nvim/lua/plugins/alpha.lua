-- #dashboard #startup #ui
---@type Utils.Pack.Spec
return {
	src = "https://github.com/goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local Snacks = require("snacks")

		local neovim = {
			type = "text",
			val = {
				[[                                                                ]],
				[[ ██████████████████████████████████████████████████████████████ ]],
				[[ █▄─▄▄─█▄─▀█▄─▄█─▄▄▄─█─█─█▄─▄█▄─▄▄▀█▄─▄█▄─▄▄▀█▄─▄█─▄▄─█▄─▀█▄─▄█ ]],
				[[ ██─▄█▀██─█▄▀─██─███▀█─▄─██─███─▄─▄██─███─██─██─██─██─██─█▄▀─██ ]],
				[[ ▀▄▄▄▄▄▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀▄▀▄▀▄▄▄▀▄▄▀▄▄▀▄▄▄▀▄▄▄▄▀▀▄▄▄▀▄▄▄▄▀▄▄▄▀▀▄▄▀ ]],
				[[                                                                ]],
				[[                                                                ]],
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
			dashboard.button(
				"p",
				" " .. " Update Plugins",
				":lua vim.pack.update()<CR>"
			),
			dashboard.button(
				"n",
				"󱀁 " .. " Neovim News",
				":lua Snacks.win({file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1], width = 0.8, height = 0.9, wo = {spell = false, wrap = false, signcolumn = 'yes', statuscolumn = ' ', conceallevel = 3}})<cr>"
			),
			dashboard.button("q", " " .. " Quit", ":qa<CR>"),
		}

		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end

		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.opts.layout[1].val = 8

		-- NOTE: disables the indent line that appears
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})

		alpha.setup(dashboard.opts)
	end,
	dependencies = {
		{ defer = true, src = "https://github.com/folke/persistence.nvim" },
	},
}

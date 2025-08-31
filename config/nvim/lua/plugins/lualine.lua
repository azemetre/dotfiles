-- #status-line #status-bar #ui
-- lualine statusline matching feline style
---@type Utils.Pack.Spec
return {
	src = "https://github.com/nvim-lualine/lualine.nvim",
	defer = true,
	dependencies = {
		{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	},
	config = function()
		local theme = require("utils.theme")
		local colors = theme.colors
		local icons = theme.icons

		local custom_theme = {
			normal = {
				a = { fg = colors.violet, bg = colors.bg, gui = "bold" },
				b = { fg = colors.fg, bg = colors.bg },
				c = { fg = colors.fg, bg = colors.bg },
			},
			insert = {
				a = { fg = colors.aqua, bg = colors.bg, gui = "bold" },
			},
			visual = {
				a = { fg = colors.magenta, bg = colors.bg, gui = "bold" },
			},
			replace = {
				a = { fg = colors.orange, bg = colors.bg, gui = "bold" },
			},
			command = {
				a = { fg = colors.green, bg = colors.bg, gui = "bold" },
			},
		}

		local function mode_with_icon()
			return icons.ghost .. " " .. require("lualine.utils.mode").get_mode()
		end

		local function file_osinfo()
			local icon
			local os_name

			if vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1 then
				icon = icons.macos
				os_name = "MAC"
			elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
				icon = icons.windows
				os_name = "WIN"
			else
				icon = icons.linux
				os_name = "LINUX"
			end

			return icon .. " " .. os_name
		end

		local function lsp_clients()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if next(clients) == nil then
				return "No LSP"
			end

			-- NOTE: #lsp-step-3
			-- INFO: If you need to change LSP name to fit lualine, you can cast a
			-- reflection spell here.
			local abbreviations = {
				lua_ls = "lua",
				["ansible-language-server"] = "ansible",
				["awk-language-server"] = "awk",
				["astro-ls"] = "astro",
				["bashls"] = "bash",
				["css-lsp"] = "css",
				["docker-language-server"] = "docker",
				["go-debug-adapter"] = "go-dap",
				["gopls"] = "go",
				["jsonls"] = "json",
				["lua-language-server"] = "lua",
				["html-lsp"] = "html",
				["taplo"] = "toml",
				["vim-language-server"] = "vim",
				["vtsls"] = "ts",
				["yaml-language-server"] = "yml",
			}

			local names = {}
			for _, client in ipairs(clients) do
				local name = abbreviations[client.name] or client.name
				table.insert(names, name)
			end
			return icons.lsp .. " " .. table.concat(names, " ")
		end

		local function diagnostics_component(severity)
			local count = #vim.diagnostic.get(
				0,
				{ severity = vim.diagnostic.severity[severity:upper()] }
			)
			if count == 0 then
				return ""
			end

			local icon_map = {
				ERROR = icons.error,
				WARN = icons.warning,
				INFO = icons.info,
				HINT = icons.hint,
			}

			return icon_map[severity:upper()] .. " " .. count
		end

		require("lualine").setup({
			options = {
				theme = custom_theme,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = {
					{
						mode_with_icon,
						color = function()
							local mode_colors = {
								n = colors.violet,
								i = colors.aqua,
								v = colors.magenta,
								V = colors.magenta,
								["^V"] = colors.blue,
								R = colors.orange,
								c = colors.green,
								s = colors.orange,
								S = colors.orange,
								["^S"] = colors.orange,
								t = colors.green,
							}
							local current_mode = vim.api.nvim_get_mode().mode
							return {
								fg = mode_colors[current_mode] or colors.orange,
								gui = "bold",
							}
						end,
					},
				},
				lualine_b = {
					{
						"filename",
						file_status = true,
						path = 0,
						symbols = {
							modified = icons.file_modified,
							readonly = icons.file_readonly,
						},
						color = { fg = colors.blue, gui = "bold" },
					},
				},
				lualine_c = {
					{
						"branch",
						fmt = function(str)
							if vim.api.nvim_strwidth(str) > 15 then
								local last_slash = str:match(".*/()")
								if last_slash then
									local suffix = str:sub(last_slash)
									local truncated = "../" .. suffix
									if vim.api.nvim_strwidth(truncated) > 15 then
										local available_chars = 15 - 3
										return "…/"
											.. suffix:sub(1, available_chars)
											.. "…"
									end
									return truncated
								else
									return "…" .. str:sub(-14)
								end
							end

							return str
						end,
						icon = icons.git,
						color = { fg = colors.violet, gui = "bold" },
					},
					{
						"diff",
						symbols = {
							added = icons.added .. " ",
							modified = icons.modified .. " ",
							removed = icons.deleted .. " ",
						},
						diff_color = {
							added = { fg = colors.green },
							modified = { fg = colors.yellow },
							removed = { fg = colors.red },
						},
					},
				},
				lualine_x = {
					{
						function()
							return diagnostics_component("error")
						end,
						color = { fg = colors.red },
					},
					{
						function()
							return diagnostics_component("warn")
						end,
						color = { fg = colors.yellow },
					},
					{
						function()
							return diagnostics_component("info")
						end,
						color = { fg = colors.blue },
					},
					{
						function()
							return diagnostics_component("hint")
						end,
						color = { fg = colors.cyan },
					},
					{
						lsp_clients,
						color = { fg = colors.grey },
					},
				},
				lualine_y = {
					{
						file_osinfo,
						color = { fg = colors.violet, gui = "bold" },
					},
					{
						"location",
						color = { fg = colors.cyan },
					},
					{
						"progress",
						color = { gui = "bold" },
					},
				},
				lualine_z = {
					{
						function()
							return icons.bsd
						end,
						color = function()
							local mode_colors = {
								n = colors.violet,
								i = colors.aqua,
								v = colors.magenta,
								V = colors.magenta,
								["^V"] = colors.blue,
								R = colors.orange,
								c = colors.green,
								s = colors.orange,
								S = colors.orange,
								["^S"] = colors.orange,
								t = colors.green,
							}
							local current_mode = vim.api.nvim_get_mode().mode
							return { fg = mode_colors[current_mode] or colors.violet }
						end,
					},
				},
			},
			inactive_sections = {
				lualine_a = {
					{
						mode_with_icon,
						color = { fg = colors.grey },
					},
				},
				lualine_b = {
					{
						"filename",
						color = { fg = colors.grey },
					},
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			extensions = {
				"fzf",
				"lazy",
				"oil",
				"trouble",
			},
		})
	end,
}

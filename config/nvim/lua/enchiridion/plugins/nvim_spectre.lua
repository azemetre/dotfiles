-- #ux #editor
-- search/replace in multiple files
--- @brief
---
--- ## Key Mappings in Spectre
--- - `?`         - Show help with all keybindings
--- - `<leader>q` - Close spectre
--- - `<Tab>`     - Navigate between input fields
--- - `<CR>`      - Go to file/line under cursor
--- - `<leader>rc`- Replace current item
--- - `<leader>R` - Replace all items
--- - `<leader>o` - Open file at current result
--- - `dd`        - Remove/exclude a result line
---
--- ## Advanced Patterns
--- Spectre supports regex patterns:
--- ```
--- Search:   function\s+(\w+)
--- Replace:  const $1 =
--- ```
return {
	"nvim-pack/nvim-spectre",
	opts = {
		color_devicons = true,
		open_cmd = "85vnew",
		live_update = false,
		lnum_for_results = true,
		line_sep_start = "┌─────────────────────────────────────────",
		result_padding = "│  ",
		line_sep = "└─────────────────────────────────────────",
		highlight = {
			ui = "String",
			search = "DiffChange",
			replace = "DiffDelete",
		},
		mapping = {
			["toggle_line"] = {
				map = "dd",
				cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
				desc = "toggle current item",
			},
			["enter_file"] = {
				map = "<cr>",
				cmd = "<cmd>lua require('spectre').enter_file()<CR>",
				desc = "goto current file",
			},
			["send_to_qf"] = {
				map = "<leader>q",
				cmd = "<cmd>lua require('spectre').send_to_qf()<CR>",
				desc = "send all items to quickfix",
			},
			["replace_cmd"] = {
				map = "<leader>c",
				cmd = "<cmd>lua require('spectre').replace_cmd()<CR>",
				desc = "input replace vim command",
			},
			["show_option_menu"] = {
				map = "<leader>o",
				cmd = "<cmd>lua require('spectre').show_options()<CR>",
				desc = "show option",
			},
			["run_current_replace"] = {
				map = "<leader>rc",
				cmd = "<cmd>lua require('spectre').run_current_replace()<CR>",
				desc = "replace current line",
			},
			["run_replace"] = {
				map = "<leader>R",
				cmd = "<cmd>lua require('spectre').run_replace()<CR>",
				desc = "replace all",
			},
			["change_view_mode"] = {
				map = "<leader>v",
				cmd = "<cmd>lua require('spectre').change_view()<CR>",
				desc = "change result view mode",
			},
			["change_replace_sed"] = {
				map = "trs",
				cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
				desc = "use sed to replace",
			},
			["change_replace_oxi"] = {
				map = "tro",
				cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
				desc = "use oxi to replace",
			},
			["toggle_live_update"] = {
				map = "tu",
				cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
				desc = "update change when vim write file.",
			},
			["toggle_ignore_case"] = {
				map = "ti",
				cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
				desc = "toggle ignore case",
			},
			["toggle_ignore_hidden"] = {
				map = "th",
				cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
				desc = "toggle search hidden",
			},
			["resume_last_search"] = {
				map = "<leader>l",
				cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
				desc = "resume last search before close",
			},
		},
		find_engine = {
			-- rg is map with finder_cmd
			["rg"] = {
				cmd = "rg",
				-- default args
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
				},
				options = {
					["ignore-case"] = {
						value = "--ignore-case",
						icon = "[I]",
						desc = "ignore case",
					},
					["hidden"] = {
						value = "--hidden",
						desc = "hidden file",
						icon = "[H]",
					},
					-- you can put any rg search option you want here it can toggle with
					-- show_option function
				},
			},
		},
		replace_engine = {
			["sed"] = {
				cmd = "sed",
				args = nil,
				options = {
					["ignore-case"] = {
						value = "--ignore-case",
						icon = "[I]",
						desc = "ignore case",
					},
				},
			},
		},
		default = {
			find = {
				--pick one of item in find_engine
				cmd = "rg",
				options = { "ignore-case" },
			},
			replace = {
				--pick one of item in replace_engine
				cmd = "sed",
			},
		},
		replace_vim_cmd = "cdo",
		is_open = false,
		is_insert_mode = false, -- start in insert mode
	},
	-- stylua: ignore
	keys = {
		{ "<leader>sr", function() 
			require("spectre").open()
		end, desc = "Replace in files (Spectre)" },
		{ "<leader>S", function() require("spectre").toggle() end, desc = "Toggle Spectre" },
		{ "<leader>sw", function() require("spectre").open_visual({select_word=true}) end, desc = "Search current word" },
		{ "<leader>sw", function() require("spectre").open_visual() end, mode = "v", desc = "Search current word" },
		{ "<leader>sp", function() require("spectre").open_file_search({select_word=true}) end, desc = "Search on current file" },
	},
}

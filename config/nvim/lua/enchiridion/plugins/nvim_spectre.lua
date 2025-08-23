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
		default = {
			find = {
				--pick one of item in find_engine
				cmd = "rg",
				options = { "ignore-case" },
			},
		},
		replace_vim_cmd = "cdo",
		is_open = false,
		is_insert_mode = false, -- start in insert mode
	},
	-- stylua: ignore
	keys = {
		{ "<leader>sr", function() 
			require("spectre").toggle()
		end, desc = "Replace in files (Spectre)" },
		{ "<leader>S", function() require("spectre").toggle() end, desc = "Toggle Spectre" },
		{ "<leader>sw", function() require("spectre").open_visual({select_word=true}) end, desc = "Search current word" },
		{ "<leader>sw", function() require("spectre").open_visual() end, mode = "v", desc = "Search current word" },
		{ "<leader>sp", function() require("spectre").open_file_search({select_word=true}) end, desc = "Search on current file" },
	},
}

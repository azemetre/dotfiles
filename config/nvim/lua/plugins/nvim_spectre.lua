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
---@type Utils.Pack.Spec
return {
	src = "https://github.com/nvim-pack/nvim-spectre",
	defer = true,
	config = function()
		local spectre = require("spectre")
		spectre.setup({
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
				["rg"] = {
					cmd = "rg",
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
					},
				},
			},
			default = {
				find = {
					cmd = "rg",
					options = { "ignore-case" },
				},
			},
			replace_vim_cmd = "cdo",
			is_open = false,
			is_insert_mode = false,
		})
		
		-- stylua: ignore
		vim.keymap.set("n", "<leader>sr", function() require("spectre").toggle() end, { desc = "Replace in files (Spectre)" })
		vim.keymap.set("n", "<leader>S", function()
			require("spectre").toggle()
		end, { desc = "Toggle Spectre" })
		vim.keymap.set("n", "<leader>sw", function()
			require("spectre").open_visual({ select_word = true })
		end, { desc = "Search current word" })
		vim.keymap.set("v", "<leader>sw", function()
			require("spectre").open_visual()
		end, { desc = "Search current word" })
		vim.keymap.set("n", "<leader>sp", function()
			require("spectre").open_file_search({ select_word = true })
		end, { desc = "Search on current file" })
	end,
}

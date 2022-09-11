local autopairs = require("nvim-autopairs")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

-- you can use some built-in conditions

autopairs.setup({
	check_ts = true,
	disable_filetype = { "TelescopePrompt", "vim" },
	ts_config = {
		lua = { "string" }, -- it will not add a pair on that treesitter node
		javascript = { "template_string" },
		typescript = { "template_string" },
	},
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

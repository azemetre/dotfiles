-- #editor #text #search
-- references
return {
	"RRethy/vim-illuminate",
	event = "BufReadPost",
	opts = { delay = 200 },
	config = function(_, opts)
		require("illuminate").configure(opts)
	end,
	keys = {
		{
			"]]",
			function()
				require("illuminate").goto_next_reference(false)
			end,
			desc = "next reference",
		},
		{
			"[[",
			function()
				require("illuminate").goto_prev_reference(false)
			end,
			desc = "prev reference",
		},
	},
}

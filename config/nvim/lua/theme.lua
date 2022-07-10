local colors = {
	bg = "#202328",
	fg = "#bbc2cf",
	aqua = "#3affdb",
	beige = "#f5c06f",
	blue = "#51afef",
	brown = "#905532",
	cyan = "#008080",
	darkblue = "#081633",
	darkorange = "#f16529",
	green = "#98be65",
	grey = "#8c979a",
	lightblue = "#5fd7ff",
	lightgreen = "#31b53e",
	magenta = "#c678dd",
	orange = "#d4843e",
	pink = "#cb6f6f",
	purple = "#834f79",
	red = "#ae403f",
	salmon = "#ee6e73",
	violet = "#a9a1e1",
	white = "#eff0f1",
	yellow = "#f09f17",
	black = "#202328",
}

local adventuretime_colors = {
	bg = "#050404", -- adventure time
	fg = "#bbc2cf",
	aqua = "#1997c6", -- adventure time
	beige = "#f8dcc0", -- adventure time
	blue = "#0f4ac6", -- adventure time
	brown = "#9b5953", -- adventure time
	cyan = "#c8faf4", -- adventure time
	darkcyan = "#70a598", -- adventure time
	darkblue = "#1E4778", -- my take
	darkorange = "#e7741e", -- adventure time
	green = "#4ab118", -- adventure time
	grey = "#545C72", -- my take
	lightblue = "#4e7cbf", -- adventure time
	lightgreen = "#9eff6e", -- adventure time
	magenta = "#F864CA", -- my take
	orange = "#F88F28", -- my take
	pink = "#F7CEF7", -- my take
	purple = "#C897EE", -- my take
	red = "#bd0013", -- adventure time
	salmon = "#fc5f5a", -- adventure time
	violet = "#665993", -- adventure time
	white = "#f6f5fb", -- adventure time
	yellow = "#efc11a", -- adventure time
	black = "#050404", -- adventure time
}

local icons = {
	-- system icons
	linux = " ",
	macos = " ",
	windows = " ",
	-- diagnostic icons
	error = "",
	warning = "",
	info = "",
	-- hint = "",
	hint = "",
	lsp = " ",
	-- lsp = "",
	line = "☰",
	-- git icons
	git = "",
	unstaged = "●",
	staged = "✓",
	unmerged = "",
	renamed = "➜",
	untracked = "★",
	deleted = "",
	ignored = "◌",
	modified = "",
	deleted = "",
	added = "",
	-- file icons
	arrow_open = "",
	arrow_closed = "",
	default = "",
	open = "",
	empty = "",
	empty_open = "",
	symlink = "",
	symlink_open = "",
	file = "",
	symlink = "",
	file_readonly = "",
	file_modified = "",
	-- misc
	devil = "",
	bsd = "",
	ghost = "",
}

return {
	colors = colors,
	icons = icons,
}

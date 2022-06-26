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

-- local colors = {
-- 	bg = "#202328",
-- 	fg = "#bbc2cf",
-- 	aqua = "#1997c6", -- adventure time
-- 	beige = "#f5c06f",
-- 	blue = "#0f4ac6", -- adventure time
-- 	brown = "#905532",
-- 	cyan = "#c8faf4", -- adventure time
-- 	darkblue = "#081633",
-- 	darkorange = "#e7741e", -- adventure time
-- 	green = "#4ab118", -- adventure time
-- 	grey = "#8c979a",
-- 	lightblue = "#5fd7ff",
-- 	lightgreen = "#9eff6e", -- adventure time
-- 	magenta = "#c678dd",
-- 	orange = "#d4843e",
-- 	pink = "#cb6f6f",
-- 	purple = "#834f79",
-- 	red = "#bd0013", -- adventure time
-- 	salmon = "#fc5f5a", -- adventure time
-- 	violet = "#665993", -- adventure time
-- 	white = "#f6f5fb", -- adventure time
-- 	yellow = "#efc11a", -- adventure time
-- 	black = "#050404", -- adventure time
-- }

-- adventure time colors
-- #050404;#bd0013;#4ab118;#e7741e;#0f4ac6;#665993;#70a598;#f8dcc0;#4e7cbf;#fc5f5a;#9eff6e;#efc11a;#1997c6;#9b5953;#c8faf4;#f6f5fb

local icons = {
	-- system icons
	linux = " ",
	macos = " ",
	windows = " ",
	-- diagnostic icons
	error = "",
	warning = "",
	info = "",
	hint = "",
	hint = "",
	lsp = " ",
	lsp = "",
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

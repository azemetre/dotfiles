local wezterm = require("wezterm")

local config = {
	-- window_background_opacity = 0.15,
	macos_window_background_blur = 30,
	enable_tab_bar = false,
	window_decorations = "RESIZE",
	font = wezterm.font_with_fallback({
		"Hack Nerd Font Mono",
		{ family = "MesloLGS NF" },
	}),
	font_size = 24,
	adjust_window_size_when_changing_font_size = true,
	native_macos_fullscreen_mode = true,
	keys = {
		{
			key = "n",
			mods = "SHIFT|CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
	},
	window_padding = {
		left = 25,
		right = 25,
		top = 25,
		bottom = 25,
	},
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = false,
	color_scheme = "Tokyo Night Storm",
}

return config

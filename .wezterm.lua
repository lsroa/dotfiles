local wezterm = require("wezterm")

local custom = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
custom.indexed[16] = '#181825'
return {
	color_schemes = {
		["togoro"] = custom,
	},
	color_scheme = "togoro",
	font = wezterm.font("Comic mono"),
	colors = {
		cursor_bg = '#a6e3a1',
	},
	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 250,
	animation_fps = 1,
	-- cell_width = 0.9,
	enable_tab_bar = false,
	font_size = 19.0,
	window_background_opacity = 0.95,
}

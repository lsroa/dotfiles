local wezterm = require("wezterm")

return {
	color_scheme = "Catppuccin Mocha",
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
	-- window_background_gradient = {
	-- 	orientation = "Vertical",
	-- 	colors = {
	-- 		-- '#121212',
	-- 		'#000000',
	-- 	},
	-- 	interpolation = "Basis",
	-- 	blend = 'Rgb'
	-- }
}

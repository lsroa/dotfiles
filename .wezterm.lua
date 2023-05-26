local wezterm = require("wezterm")

return {
	color_scheme = "Catppuccin Mocha",
	font = wezterm.font("Comic mono"),
	-- cell_width = 0.9,
	enable_tab_bar = false,
	font_size = 19.0,
	window_background_opacity = 0.9,
	window_background_gradient = {
		orientation = "Vertical",
		colors = {
			'#121212',
			'#121212',
			'#121212',
			'#121212',
			'#141E30',
			'#141E30',
			'#243B55',
		},
		interpolation = "Basis",
		blend = 'Rgb'
	}
}

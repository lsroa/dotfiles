local wezterm = require("wezterm")

local custom = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
custom.indexed[16] = '#181825'
return {
	color_schemes = {
		["togoro"] = custom,
	},
	color_scheme = "togoro",
	font = wezterm.font("Comic mono"),
	font_rules = {
		{
			intensity = 'Normal',
			font = wezterm.font('JetbrainsMono Nerd Font Mono', { weight = 500 })
		},
		{
			intensity = 'Bold',
			font = wezterm.font({
				family = 'JetbrainsMono Nerd Font Mono',
				weight = 'Bold',
				italic = true,
			}),
		}
	},
	colors = {
		cursor_bg = '#a6e3a1',
	},
	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 250,
	animation_fps = 1,
	-- cell_width = 0.9,
	enable_tab_bar = false,
	font_size = 16,
}

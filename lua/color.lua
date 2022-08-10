vim.cmd([[
	if (has("termguicolors"))
   set termguicolors
  endif
]])

local cp = require("catppuccin.palettes").get_palette "mocha"

local oxo = {
	black = "#161616",
	gray2 = "#262626",
	gray1 = "#393939",
	gray = "#525252",
	text = "#dde1e6",
	text1 = "#f2f4f8",
	white = "#ffffff",
	dark_aqua = "#08bdba",
	aqua = "#3ddbd9",
	mid_blue = "#78a9ff",
	pink = "#ee5396",
	blue = "#33b1ff",
	light_pink = "#ff7eb6",
	green = "#42be65",
	purple = "#be95ff",
	light_blue = "#82cfff",
	bg = "#131313",
}

-- local cat = require 'catppuccin'
local custom_highlights = {
	DiffAdd = {
		bg = '#005f5f',
	},
	DiffDelete = {
		bg = '#875f5f'
	},
	DiffText = {
		fg = cp.green,
		bg = '#007f7f',
	},
	DiffChange = {
		bg = '#005f5f',
	},
	NeogitHunkHeader = {
		bg = '#525252'
	},
	IndentBlankLineIndent1 = {
		bg = '#222222'
	},
	GitSignsDeleteLn = {
		bg = '#875f5f'
	},
	GitSignsDelete = {
		fg = '#ff5555'
	},
	NeoTreeEndOfBuffer = {
		fg = '#161616'
	},
	NeoTreeDirectoryName = { fg = oxo.blue },
	NeoTreeDirectoryIcon = { fg = oxo.blue },
	NeoTreeIndentMarker = { fg = oxo.gray },
	NeoTreeSymbolicLinkTarget = { fg = oxo.pink },
	NeoTreeGitModified = {
		fg = oxo.aqua
	},
	NeoTreeGitConflict = {
		fg = "#ff5555"
	},
	NeoTreeUntracked = { fg = oxo.blue },
	NeoTreeFileNameOpened = { fg = oxo.pink },
}

-- cat.setup {
-- 	custom_highlights = custom_highlights,
-- 	term_colors = true,
-- 	integrations = {
-- 		gitsigns = true,
-- 		neogit = true,
-- 		dap = true,
-- 		treesitter = true,
-- 		telescope = true,
-- 		neotree = {
-- 			enabled = true,
-- 			show_root = true,
-- 			transparent_panel = true
-- 		},
-- 	}
-- }

require 'colorizer'.setup()

vim.cmd([[colorscheme oxocarbon-lua]])

for name, hl in pairs(custom_highlights) do
	vim.api.nvim_set_hl(0, name, hl)
end

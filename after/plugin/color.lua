vim.cmd([[
   set termguicolors
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
	red = "#ff5555",
	yellow = "#f1e05a"

}

-- local cat = require 'catppuccin'
local custom_highlights = {
	DiffAdd = {
		bg = '#005f5f',
	},
	NeogitDiffAddRegion = {
		bg = '#005f5f',
	},
	NeogitDiffAdd = {
		bg = '#005f5f',
	},
	NeogitDiffDelete = {
		bg = '#875f5f'
	},
	NeogitDiffDeleteRegion = {
		bg = '#875f5f'
	},
	DiffDelete = {
		bg = '#875f5f'
	},
	DiffText = {
		bg = '#007f7f',
	},
	DiffChange = {
		bg = '#005f5f',
	},
	NeogitHunkHeader = {
		bg = '#525252',
	},
	-- IndentBlankLineIndent1 = {
	-- 	bg = '#222222'
	-- },
	GitSignsDeleteLn = {
		bg = '#875f5f'
	},
	-- GitSignsDelete = {
	-- 	fg = oxo.red
	-- },
	-- NeoTreeEndOfBuffer = {
	-- 	fg = oxo.bg
	-- },
	-- NeoTreeDirectoryName = { fg = oxo.text },
	-- NeoTreeDirectoryIcon = { fg = oxo.text },
	-- NeoTreeIndentMarker = { fg = oxo.gray },
	-- NeoTreeSymbolicLinkTarget = { fg = oxo.pink },
	-- NeoTreeGitModified = {
	-- 	fg = oxo.aqua
	-- },
	-- NeoTreeGitConflict = {
	-- 	fg = oxo.red
	-- },
	-- NeoTreeGitUntracked = { fg = oxo.blue },
	-- NeoTreeFileNameOpened = { fg = oxo.pink },
	-- TelescopeBorder = {
	-- 	fg = oxo.text
	-- },
	-- FloatBorder = {
	-- 	fg = oxo.text
	-- },
	-- Cursor = {
	-- 	fg = oxo.yellow,
	-- 	bg = oxo.black
	-- }
}

require('catppuccin').setup {
	custom_highlights = custom_highlights,
	term_colors = true,
	transparent_background = true,
	integrations = {
		gitsigns = true,
		neogit = true,
		dap = true,
		treesitter = true,
		telescope = true,
		neotree = {
			enabled = true,
			show_root = true,
			transparent_panel = true
		},
	}
}

require 'colorizer'.setup()

-- require 'material'.setup {
-- 	disable = {
-- 		background = true
-- 	},
-- 	plugins = {
-- 		'nvim-tree'
-- 	}
-- }

vim.cmd([[colorscheme catppuccin]])
-- vim.cmd([[
-- 		highlight Normal guibg=none
-- 		highlight NonText guibg=none
-- ]])
-- vim.g.material_style = "deep ocean"

-- for name, hl in pairs(custom_highlights) do
-- 	vim.api.nvim_set_hl(0, name, hl)
-- end

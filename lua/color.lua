vim.cmd([[
	if (has("termguicolors"))
   set termguicolors
  endif
]])

local cp = require("catppuccin.palettes").get_palette "mocha"
local cat = require 'catppuccin'
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
	typescriptDecorator = { fg = cp.orange },
	NeogitHunkHeader = {
		bg = cp.surface0
	},
	MiniTablineModifiedCurrent = {
		fg = cp.yellow
	},
	IndentBlankLineIndent1 = {
		bg = cp.surface0
	},
}

cat.setup {
	custom_highlights = custom_highlights,
	term_colors = true,
	integrations = {
		neogit = true,
		dap = true
	}
}

require 'colorizer'.setup()

vim.cmd([[colorscheme catppuccin]])

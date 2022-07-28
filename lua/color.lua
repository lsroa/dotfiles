vim.cmd([[
	if (has("termguicolors"))
 	  set termguicolors
 	endif
]])

local cp = require 'catppuccin.api.colors'.get_colors()
local cat = require 'catppuccin'
cat.setup {
	integrations = {
		neogit = true
	}
}
cat.remap({
	DiffAdd = {
		bg = '#005f5f',
	},
	DiffDelete = {
		bg = '#875f5f'
	},
	DiffText = {
		fg = cp.green,
		bg = '#238636',
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
	}
})
require 'colorizer'.setup()

vim.cmd([[colorscheme catppuccin]])

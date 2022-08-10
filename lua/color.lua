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
	IndentBlankLineIndent1 = {
		bg = cp.surface0
	},
	NeoTreeModified = {
		fg = cp.lavander
	},
	NeoTreeGitDeleted = {
		fg = cp.red
	},
	NeoTreeGitModified = {
		fg = cp.blue
	},
	NeoTreeGitUntracked = {
		fg = cp.green
	}
}

cat.setup {
	custom_highlights = custom_highlights,
	term_colors = true,
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

vim.cmd([[colorscheme catppuccin]])

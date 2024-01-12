return {
	"catppuccin/nvim",
	name = "catppuccin",
	dependencies = {
		{
			'norcalli/nvim-colorizer.lua',
			name = "colorizer"
		}
	},
	config = function()
		vim.cmd([[
			set termguicolors
		]])

		require('catppuccin').setup {
			custom_highlights = {
				DiffAdd = {
					bg = '#005f5f',
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
				CursorLine = {
					bg = '#181825',
				},
				LspInlayHint = {
					link = 'Comment'
				},
				GitSignsDeleteLn = {
					bg = '#875f5f'
				},
				DapBreakpoint = {
					fg = '#f7df1e'
				},
				WinSeparator = {
					fg = '#45475a',
					bg = 'None'
				},
				MatchParen = {
					fg = 'none',
					bg = '#525252',
				},
				Folded = {
					fg = '#45475a',
				},
				NvimTreeOpenedFile = {
					fg = '#cdd6f4',
					style = {
						'bold'
					},
				},
			},
			term_colors = true,
			transparent_background = true,
			integrations = {
				gitsigns = true,
				dap = true,
				treesitter = true,
				telescope = true,
			}
		}

		require 'colorizer'.setup()

		vim.cmd([[
			set termguicolors
			colorscheme catppuccin
		]])
	end
}

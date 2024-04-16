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
				NvimTreeGitStaged = {
					fg = "#005f5f"
				},
				NvimTreeModifiedFile = {
					link = 'NvimTreeNormal',
				},
				NvimTreeFileMerge = {
					link = 'NvimTreeNormal',
				},
				NvimTreeFileNew = {
					link = 'NvimTreeNormal',
				},
				NvimTreeFileStaged = {
					link = 'NvimTreeNormal',
				},
				NvimTreeFileRenamed = {
					link = 'NvimTreeNormal',
				},
				NvimTreeFileDirty = {
					link = 'NvimTreeNormal',
				},
				NvimTreeFolderName = {
					link = 'NvimTreeNormal',
				},
				NvimTreeGitMerge = {
					link = 'NvimTreeNormal',
				},
				NvimTreeFolderOpened = {
					link = 'NvimTreeNormal',
				},
				NvimTreeFolderStaged = {
					link = 'NvimTreeNormal',
				},
				NvimTreeFolderDirty = {
					link = 'NvimTreeNormal',
				},
				NvimTreeNormal = {
					bg = '#232325',
					fg = '#a6adc8',
				},
				NvimTreeOpenedFile = {
					bg = '#232325',
					fg = '#cad3f1',
					style = {
						'bold'
					}
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

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
			},
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

		vim.cmd([[
			set termguicolors
			colorscheme catppuccin
		]])
	end
}

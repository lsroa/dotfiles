return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	dependencies = {
		'p00f/nvim-ts-rainbow',
		'windwp/nvim-ts-autotag',
	},
	config = function()
		require 'nvim-treesitter.configs'.setup {
			highlight = {
				enable = true,
			},
			autotag = {
				enable = true
			},
			rainbow = {
				colors = {
					"#FF5555",
					"#65DEF1",
					"#F3CA40",
					"#FF88DC",
				},
				enable = false,
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = 1000,
			}
		}
	end
}

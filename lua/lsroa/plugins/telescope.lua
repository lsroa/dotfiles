return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	config = function()
		require 'telescope'.setup {
			defaults = {
				layout_strategy = "horizontal",
				path_display = { "truncate" },
				layout_config = {
					horizontal = {
						preview_width = 80,
						preview_cutoff = 140,
						height = 0.9,
					},
				}
			},
			mappings = {
				i = {
					["<Leader>q"] = require 'telescope.actions'.close
				},
				n = {
					["<Leader>q"] = require 'telescope.actions'.close
				}
			},
		}
	end
}

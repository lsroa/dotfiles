return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-ui-select.nvim'
	},
	config = function()
		require 'telescope'.setup {
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown {}
				}
			},
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
		require("telescope").load_extension("ui-select")
	end
}

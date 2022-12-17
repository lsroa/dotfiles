require 'telescope'.setup {
	file_ignore_patterns = { "node_modules" },
	layout_strategy = 'center',
	height = 0.9,
	layout_config = {
		preview_cutoff = 3,
		anchor = 'N'
	},
	mappings = {
		i = {
			["<Leader>q"] = require 'telescope.actions'.close
		},
		n = {
			["<Leader>q"] = require 'telescope.actions'.close
		}
	}
}

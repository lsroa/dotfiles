require 'telescope'.setup {
	defaults = {
		layout_strategy = "horizontal",
		path_display = { "truncate" },
		layout_config = {
			horizontal = {
				preview_width = 120,
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

require("telescope").load_extension "harpoon"

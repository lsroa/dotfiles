return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	dependencies = {
		'nvim-treesitter/playground',
		'p00f/nvim-ts-rainbow',
		'windwp/nvim-ts-autotag',
		'nvim-treesitter/nvim-treesitter-context',
	},
	config = function()
		require 'nvim-treesitter.configs'.setup {
			ensure_install = { "javascript", "jsdoc", "vue", "css", "json" },
			highlight = {
				enable = true,
			},
			playground = {
				enable = true,
				keybindings = {
					toggle_hl_groups = 'i',
					show_help = '?'
				}
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
				enable = true,
				-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = 1000,
			}
		}

		require 'treesitter-context'.setup {
			enable = true
		}
	end
}

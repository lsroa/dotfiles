return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-ui-select.nvim',
		'nvim-telescope/telescope-file-browser.nvim',
	},
	config = function()
		local fb_actions = require('telescope').extensions.file_browser.actions
		require 'telescope'.setup {
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown {}
				},
				file_browser = {
					hidden = true,
					previewer = false,
					theme = "dropdown",
					display_stat = false,
					grouped = true,
					git_status = false,
					mappings = {
						i = {
							["<C-a>"] = fb_actions.create,
							["<C-r>"] = fb_actions.rename,
							["<C-y>"] = fb_actions.copy,
							["<C-d>"] = fb_actions.remove,
							["<C-h>"] = fb_actions.toggle_hidden,
						},
						n = {
							["rn"] = fb_actions.rename,
							["y"] = fb_actions.copy,
							["d"] = fb_actions.remove,
							["H"] = fb_actions.toggle_hidden,
							["."] = fb_actions.change_cwd,
							["<BS>"] = fb_actions.goto_parent_dir,
							["a"] = fb_actions.create,
						}
					},
				},
			},
			pickers = {
				buffers = {
					previewer = false,
					theme = "dropdown",
					ignore_current_buffer = true,
					sort_lastused = true,
					mappings = {
						n = {
							["dd"] = require 'telescope.actions'.delete_buffer
						}
					}
				},
			},
			mappings = {
				n = {
					["<leader>q"] = require 'telescope.actions'.close,
				}
			},
		}

		local opts = { noremap = true, silent = true }

		vim.keymap.set("n", "<space>o", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", opts)

		vim.keymap.set('n', '<Leader>ff',
			function()
				local width = vim.fn.winwidth(0) < 150 and 0.6 or 0.45
				require('telescope.builtin').find_files(require('telescope.themes').get_dropdown {
					previewer = false,
					layout_config = {
						width = width,
					},
					path_display = { "filename_first" },
				})
			end,
			opts
		)

		vim.keymap.set('n', '<Leader>fg', function()
			require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown {
				path_display = { "tail" },
				layout_config = {
					width = vim.fn.winwidth(0) > 150 and 0.4 or 0.5,
				}
			})
		end, opts)

		vim.keymap.set('n', '<Leader>fs', function()
			require('telescope.builtin').git_status(require('telescope.themes').get_dropdown {
				path_display = { "filename_first" },
				previewer = false,
			})
		end, opts)

		vim.keymap.set('n', '/', ':Telescope current_buffer_fuzzy_find<CR>', opts)

		vim.keymap.set('n', '<Leader>fb', function()
			require "telescope.builtin".buffers({
				previewer = false,
				layout_config = {
					width = 0.4,
				},
				sort_lastused = true,
			})
		end, opts)
		vim.keymap.set('n', '<Leader>fh', ':Telescope help_tags<CR>', opts)

		require("telescope").load_extension("ui-select")
		require("telescope").load_extension "file_browser"
	end
}

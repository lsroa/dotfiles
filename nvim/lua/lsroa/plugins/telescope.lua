return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    {
      "danielfalk/smart-open.nvim",
      config = function()
        require("telescope").load_extension("smart_open")
      end,
      dependencies = {
        "kkharji/sqlite.lua",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
    },
  },
  config = function()
    local fb_actions = require('telescope').extensions.file_browser.actions
    require 'telescope'.setup {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
            layout_config = {
              width = 0.2
            },
          }
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


    vim.keymap.set('n', '<Leader>fs', function()
      require('telescope.builtin').git_status(require('telescope.themes').get_dropdown {
        path_display = { "filename_first" },
        previewer = false,
      })
    end, opts)

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
    require("telescope").load_extension "fzf"
  end
}

local multigrep = function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")
  local conf = require("telescope.config").values
  opts = opts or {}
  opts.cwd = opts.cwd or vim.fn.getcwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "  ")

      local args = { "rg" }

      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, string.format("%s", pieces[2]))
      end
      return vim.tbl_flatten(args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" })
    end,
    cwd = opts.cwd,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    previewer = conf.grep_previewer(opts),
    sorter = require("telescope.sorters").empty()
  }

  pickers.new(opts, {
    debounce = 100,
    prompt_title = "Multigrep",
    finder = finder,
  }):find()
end

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
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

    vim.keymap.set("n", "<Leader>o", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", opts)

    vim.keymap.set('n', '<Leader>ff',
      function()
        local width = vim.fn.winwidth(0) < 150 and 0.5 or 0.45
        require("telescope").extensions.smart_open.smart_open((require('telescope.themes').get_dropdown {
          previewer = false,
          layout_config = {
            width = width,
          },
          path_display = { "filename_first" },
        }))
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

    vim.keymap.set('n', '<Leader>mg', multigrep, opts)

    require("telescope").load_extension("ui-select")
    require("telescope").load_extension "file_browser"
    require("telescope").load_extension "fzf"
  end
}

vim.g.mapleader = ' '

-- Yanked highlight
local yank_group = vim.api.nvim_create_augroup('HighlightYank', {})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 200,
    })
  end,
})

vim.filetype.add({
  extension = {
    frag = 'glsl',
    vert = 'glsl',
  }
})


-- Diagnostics settings
vim.diagnostic.config({
  virtual_text = false,
  float = { border = 'rounded' }
})


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  change_detection = { notify = false },
  'editorconfig/editorconfig-vim',
  'tpope/vim-commentary',
  { 'MunifTanjim/nui.nvim' },
  {
    'mhartington/formatter.nvim',
    dependencies = {
      {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
          -- Automatically install LSPs to stdpath for neovim
          { 'williamboman/mason.nvim', config = true },
          'williamboman/mason-lspconfig.nvim',
        },
      },
    },
    config = function()
      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd
      augroup("__formatter__", { clear = true })
      autocmd("BufWritePost", {
        group = "__formatter__",
        command = ":FormatWrite",
      })

      require("formatter").setup({
        -- Enable or disable logging
        logging = false,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        filetype = {
          typescriptreact = {
            require("formatter.filetypes.typescriptreact").prettier,
          },
          typescript = {
            require("formatter.filetypes.typescript").prettier,
          },
          sql = {
            require("formatter.filetypes.sql").sql_formatter,
          },
          python = {
            require("formatter.filetypes.python").black,
          },
          html = {
            require("formatter.filetypes.html").prettier,
          },
          scss = {
            require("formatter.filetypes.css").prettier,
          },
        }
      })
    end
  },
  {
    'mfussenegger/nvim-lint',
    config = function()
      require("lint").linters_by_ft = {
        html = { "htmlhint" },
        scss = { "stylelint" },
        python = { "flake8" }
      }

      vim.api.nvim_create_user_command("Lint", function()
        print("linting")
        require("lint").try_lint()
      end, {})

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          print("linting")
          require("lint").try_lint()
        end,
      })
    end,
    ft = { "html", "scss", "python" }
  },
  { 'itchyny/vim-qfedit',  ft = 'qf' },
  {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup(
        {
          keymaps = {
            ["g?"] = { "actions.show_help", mode = "n" },
            ["<CR>"] = "actions.select",
            ["<C-s>"] = { "actions.select", opts = { vertical = true } },
            ["<C-t>"] = { "actions.select", opts = { tab = true } },
            ["<C-p>"] = "actions.preview",
            ["<C-c>"] = { "actions.close", mode = "n" },
            ["-"] = { "actions.parent", mode = "n" },
            ["_"] = { "actions.open_cwd", mode = "n" },
            ["`"] = { "actions.cd", mode = "n" },
            ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
            ["gs"] = { "actions.change_sort", mode = "n" },
            ["gx"] = "actions.open_external",
            ["g."] = { "actions.toggle_hidden", mode = "n" },
          },
          float = {
            gen_win_title = function() return vim.fn.expand("%:p:h") end,
            max_width = vim.fn.winwidth(0) < 150 and 0.5 or 0.45,
            max_height = 0.5,
            border = "rounded",
          }
        }
      )

      vim.keymap.set("n", "<Leader>o",
        function()
          require("oil").open_float(vim.fn.expand("%:p:h"), { pickers = "files" })
        end,
        { noremap = true, silent = true }
      )
    end
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    },
    config = function()
      require('auto-session').setup({})
    end
  },
  {
    'nvim-mini/mini.nvim',
    version = false,
    config =
        function()
          require('mini.cursorword').setup()
        end
  },
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('harpoon').setup({ menu = { width = 120 } })
      -- map add file
      vim.keymap.set('n', '<Leader>i',
        function()
          require("harpoon.mark").add_file()
        end,
        { noremap = true }
      )
      -- map toggle menu
      vim.keymap.set('n', '<Leader>fk',
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        { noremap = true }
      )

      vim.keymap.set('n', '<Tab>',
        function()
          require("harpoon.ui").nav_next()
        end,
        { noremap = true }
      )

      vim.keymap.set('n', '<S-Tab>',
        function()
          require("harpoon.ui").nav_prev()
        end,
        { noremap = true }
      )
    end
  },
  {
    'sindrets/diffview.nvim',
    name = "diffview",
    config = function()
      require 'diffview'.setup {
        use_icons = true,
        signs = {
          fold_closed = "+",
          fold_open = "-"
        },
        view = {
          default = {
            -- Config for changed files, and staged files in diff views.
            layout = "diff2_horizontal",
            winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
          },
          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = "diff3_mixed",
            disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
            winbar_info = false,        -- See ':h diffview-config-view.x.winbar_info'
          },
        },
        file_panel = {
          listing_style = "tree",            -- One of 'list' or 'tree'
          tree_options = {                   -- Only applies when listing_style is 'tree'
            flatten_dirs = true,             -- Flatten dirs that only contain one single dir
            folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
          },
          win_config = {                     -- See ':h diffview-config-win_config'
            position = "left",
            width = 40,
            win_opts = {}
          },
        },
        default_args = {
          DiffviewOpen = { "--imply-local" },
        }
      }
    end
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    config = function()
      require("ibl").setup({
        indent = {
          char = '┊',
        },
        scope = {
          enabled = false
        }
      })
    end,
    enabled = true,
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {

      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local has_words_before = function()
        local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require 'cmp'

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ["<cr>"] = cmp.mapping.confirm(),
          ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = "path" }
        }, {
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  },
  { import = 'lsroa.plugins' },
})

require("lsroa.keymaps")
require("lsroa.options")
require("lsroa.lsp")

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '×',
      [vim.diagnostic.severity.WARN] = '‣',
      [vim.diagnostic.severity.HINT] = '•',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
})

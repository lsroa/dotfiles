vim.g.mapleader = ' '

-- Disable some builtin vim plugins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

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

  'editorconfig/editorconfig-vim',
  'christoomey/vim-tmux-navigator',
  'tpope/vim-commentary',
  {
    disabled = true,
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false, debounce = 0 },
        panel = { enabled = false },
        filetypes = {
          cpp = false
        }
      })
    end
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "hrsh7th/nvim-cmp"
    },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "karb94/neoscroll.nvim",
    enabled = false,
    config = function()
      require('neoscroll').setup({})
    end
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      smear_between_neighbor_lines = false,
    },
  },
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
      require("formatter").setup({
        -- Enable or disable logging
        logging = false,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        filetype = {
          typescriptreact = {
            -- require("formatter.filetypes.typescriptreact").prettier,
            require("formatter.filetypes.typescriptreact").biome,
          },
          typescript = {
            require("formatter.filetypes.typescript").prettier,
          },
          sql = {
            require("formatter.filetypes.sql").sql_formatter,
          }
        }
      })
    end
  },
  { 'itchyny/vim-qfedit',  ft = 'qf' },
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
  { "rmagatti/auto-session", opts = { auto_save_enabled = true } },
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

      -- Edit Snippets

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
          { name = "copilot" },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
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
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
})

local signs = {
  { text = "DapBreakpoint", icon = "💔" },
  { text = "DapStopped", icon = '👉' },
}



for _, sign in pairs(signs) do
  vim.fn.sign_define(sign.text, {
    text = sign.icon,
    texthl = sign.text,
    linehl = "",
    numhl = ""
  })
end

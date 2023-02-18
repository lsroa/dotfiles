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
	"matchparen",
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

require 'lsroa.keymaps'

-- Diagnostics settings
vim.diagnostic.config({
	float = {
		border = 'rounded'
	}
})

require 'lsroa.globals'
require 'lsroa.options'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

	'nvim-lualine/lualine.nvim',
	{ 'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		dependencies = {
			'nvim-treesitter/playground',
			'p00f/nvim-ts-rainbow',
			'windwp/nvim-ts-autotag',
			'nvim-treesitter/nvim-treesitter-context',
		}
	},
	'christoomey/vim-tmux-navigator',
	'norcalli/nvim-colorizer.lua',
	'markonm/traces.vim',
	'marko-cerovac/material.nvim',
	'projekt0n/github-nvim-theme',
	{ 'catppuccin/nvim', name = 'catppuccin' },
	'MunifTanjim/nui.nvim',
	'nvim-lua/plenary.nvim',
	{
		'nvim-neo-tree/neo-tree.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
		}
	},
	'B4mbus/oxocarbon-lua.nvim',
	{ 'ThePrimeagen/harpoon',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
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
		end
	},
	'neovim/nvim-lspconfig',
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
		}
	},
	'editorconfig/editorconfig-vim',
	'tpope/vim-commentary',

	'TimUntersberger/neogit',
	'sindrets/diffview.nvim',
	'lewis6991/gitsigns.nvim',

	'Shatur/neovim-session-manager',
	'goolord/alpha-nvim',
	{
		'mfussenegger/nvim-dap',
		dependencies = {
			'theHamsta/nvim-dap-virtual-text',
		}
	},
	{ 'leoluz/nvim-dap-go', ft = 'go' },
	'jose-elias-alvarez/null-ls.nvim',
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		-- event = "InsertEnter",
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
		},
	},
	'L3MON4D3/LuaSnip',
	'saadparwaiz1/cmp_luasnip',
	'rafamadriz/friendly-snippets',
	{
		dir = '/Users/luis.roa/Developer/vim-view/main',
		config = function()
			require('vim-view').setup()
		end
	}
})

-- Signs
local signs = {
	DiagnosticSignError = 'E',
	DiagnosticSignWarn = 'W',
	DiagnosticSignHint = 'H',
	DiagnosticSignInfo = 'I',
	DapBreakpoint = 'B',
	DapStopped = '*',
}

for type, icon in pairs(signs) do
	vim.fn.sign_define(type, { text = icon, texthl = type, numhl = type })
end

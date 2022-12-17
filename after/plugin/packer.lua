-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use 'nvim-lualine/lualine.nvim'
	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
	use 'nvim-treesitter/playground'
	use 'p00f/nvim-ts-rainbow'
	use 'windwp/nvim-ts-autotag'
	use 'nvim-treesitter/nvim-treesitter-context'
	use 'norcalli/nvim-colorizer.lua'

	use 'lewis6991/impatient.nvim'
	use 'markonm/traces.vim'

	use 'marko-cerovac/material.nvim'
	use 'projekt0n/github-nvim-theme'
	use { 'catppuccin/nvim', as = 'catppuccin' }
	use 'MunifTanjim/nui.nvim'

	use { 'nvim-neo-tree/neo-tree.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
	}
	use 'B4mbus/oxocarbon-lua.nvim'
	use 'christoomey/vim-tmux-navigator'

	use 'neovim/nvim-lspconfig'
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'
	use { 'nvim-telescope/telescope.nvim',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use 'editorconfig/editorconfig-vim'

	use 'tpope/vim-commentary'

	use 'TimUntersberger/neogit'
	use 'sindrets/diffview.nvim'
	use 'lewis6991/gitsigns.nvim'

	use 'Shatur/neovim-session-manager'
	use 'goolord/alpha-nvim'

	use 'mfussenegger/nvim-dap'
	use 'leoluz/nvim-dap-go'
	use 'theHamsta/nvim-dap-virtual-text'

	use 'nvim-neotest/neotest'
	use 'haydenmeade/neotest-jest'

	use 'jose-elias-alvarez/null-ls.nvim'

	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'

	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
	use 'rafamadriz/friendly-snippets'

	use 'danymat/neogen'
	-- use '/Users/luis.roa/Developer/vim-view/main'
end)

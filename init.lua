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


-- Diagnostics settings
vim.diagnostic.config({
	virtual_text = false,
	float = { border = 'rounded' }
})


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

	'editorconfig/editorconfig-vim',
	'christoomey/vim-tmux-navigator',
	'tpope/vim-commentary',
	{
		enabled = false,
		'Lilja/zellij.nvim',
		config = function()
			require('zellij').setup({
				vimTmuxNavigatorKeybinds = true,
			})
		end
	},
	'MunifTanjim/nui.nvim',
	'jose-elias-alvarez/null-ls.nvim',
	{ 'github/copilot.vim', enabled = false },
	{ 'weilbith/nvim-code-action-menu', cmd = 'CodeActionMenu' },
	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ 'williamboman/mason.nvim', config = true },
			'williamboman/mason-lspconfig.nvim',
		},
	},
	{ 'nvim-lualine/lualine.nvim',
		config = function()
			require 'lualine'.setup {
				options = {
					icons_enabled = false,
					component_separators = '',
					section_separators = ''
				}
			}
		end
	},
	{ "theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup({})
		end
	},
	{ "mfussenegger/nvim-dap",
		requires = { "nvim-dap-virtual-text" },
		config = function()
			vim.keymap.set("n", "<Leader>b",
				function()
					require 'dap'.toggle_breakpoint()
				end,
				{ noremap = true })

			vim.keymap.set("n", "<Leader>dc",
				function()
					require 'dap'.continue()
				end,
				{ noremap = true })

			vim.keymap.set("n", "<Leader>dr",
				function()
					require 'dap'.repl.open()
				end,
				{ noremap = true })

			vim.keymap.set("n", "]d",
				function()
					require 'dap'.step_over()
				end,
				{ noremap = true })

			vim.keymap.set("n", "[d",
				function()
					require 'dap'.step_into()
				end,
				{ noremap = true })

			vim.keymap.set("n", "<Leader>dk",
				function()
					require("dap.ui.widgets").hover()
				end,
				{ noremap = true })
		end
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		requires = { "mfussenegger/nvim-dap" },
		build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
		enabled = false,
		ft = "typescript"
	},
	{
		"leoluz/nvim-dap-go",
		requires = {
			"mfussenegger/nvim-dap",
			"nvim-dap-virtual-text"
		},
		config = function()
			local dap_go = require('dap-go')
			dap_go.setup()
			vim.keymap.set("n", "<Leader>dt",
				function()
					dap_go.debug_test()
				end,
				{ noremap = true })
		end,
		ft = "go"
	},

	{ 'ThePrimeagen/harpoon',
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
		end
	},
	{
		'TimUntersberger/neogit',
		enabled = false,
		opts = {
			disable_context_highlighting = true,
			integrations = {
				diffview = true
			},
			commit_popup = {
				kind = "vsplit",
			},
			popup = {
				kind = "vsplit",
			}
		}
	},
	{ 'sindrets/diffview.nvim',
		name = "diffview",
		config = function()
			require 'diffview'.setup {
				use_icons = false,
				signs = {
					fold_closed = "+",
					fold_open = "-"
				}
			}

			vim.keymap.set('n', '<Leader>dd', ':DiffviewOpen<CR>', { noremap = true })
			vim.keymap.set('n', '<Leader>df', ':DiffviewClose<CR>', { noremap = true })

		end
	},
	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		opts = {
			char = '┊',
			show_trailing_blankline_indent = false,
		},
		enabled = true,
	},
	{ "rmagatti/auto-session", opts = { auto_save_enabled = true } },
	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-cmdline',

			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
	},
	{ import = 'lsroa.plugins' },
})

require("lsroa.keymaps")
require("lsroa.globals")
require("lsroa.options")
require("lsroa.lsp")
require("lsroa.autocmp")

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

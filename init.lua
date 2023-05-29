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


-- Diagnostics settings
vim.diagnostic.config({
	virtual_text = false,
	float = {
		border = 'rounded'
	}
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

require("lsroa.keymaps")
require("lsroa.globals")
require("lsroa.options")

require('lazy').setup({

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
	'christoomey/vim-tmux-navigator',
	'MunifTanjim/nui.nvim',
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
		'weilbith/nvim-code-action-menu',
		cmd = 'CodeActionMenu',
	},
	{ 'github/copilot.vim' },
	'neovim/nvim-lspconfig',
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',

	'editorconfig/editorconfig-vim',
	'tpope/vim-commentary',

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

	{ "rmagatti/auto-session", opts = {} },
	'jose-elias-alvarez/null-ls.nvim',
	{ import = 'lsroa.plugins' },
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

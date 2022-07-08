vim.cmd([[
call plug#begin()

Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'norcalli/nvim-colorizer.lua'

Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'markonm/traces.vim'

Plug 'marko-cerovac/material.nvim'
Plug 'projekt0n/github-nvim-theme'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'tpope/vim-commentary'

Plug 'TimUntersberger/neogit'
Plug 'sindrets/diffview.nvim'
Plug 'lewis6991/gitsigns.nvim'

Plug 'Shatur/neovim-session-manager'
Plug 'goolord/alpha-nvim'


Plug 'mfussenegger/nvim-dap'
Plug 'leoluz/nvim-dap-go' 
Plug 'theHamsta/nvim-dap-virtual-text'

Plug 'jose-elias-alvarez/null-ls.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'danymat/neogen'

call plug#end()
]])

vim.g.mapleader = ' '

-- Auto pair
vim.cmd([[
  inoremap ( ()<left>
  inoremap [ []<left>
  inoremap { {}<left>
  inoremap {<CR> {<CR>}<ESC>O
  inoremap {;<CR> {<CR>};<ESC>O
  inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
  inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
  inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
  inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
  inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
]])

-- Yanked highlight
vim.cmd([[
	autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=500}
]])

-- Status bar

require 'lualine'.setup {
	options = {
		icons_enabled = false,
		component_separators = '',
		section_separators = ''
	}
}
require 'options'
require 'keymaps'

-- Indent
vim.opt.list = true
require("indent_blankline").setup {}

require 'dashboard'
require 'debugger'
require 'autocmp'

-- Diagnostics settings
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	severity_sort = false,
	update_in_insert = false,
	float = {
		border = 'rounded'
	}
})

-- Setup lspconfig
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- LSP settings
local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
}

-- Formatting
local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(clients)
			return vim.tbl_filter(function(client)
				return client.name ~= "tsserver"
			end, clients)
		end,
		bufnr = bufnr,
		-- async = true,
	})
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)

	if client.supports_method('textDocument/formatting') then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_formatting(bufnr)
			end
		})
	end

	local opts = { noremap = true, silent = true }
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>k', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>rf',
		'<cmd>lua require"telescope.builtin".lsp_references({layout_strategy = "horizontal" })<CR>', opts)
end

-- Null lsp
local null_ls = require 'null-ls'

null_ls.setup({
	sources = {
		-- null_ls.builtins.formatting.eslint.with({
		-- 	disabled_filetypes = { 'vue' },
		-- 	command = "node_modules/.bin/eslint"
		-- }),
		null_ls.builtins.diagnostics.eslint.with({
			disabled_filetypes = { 'vue' },
			command = "node_modules/.bin/eslint"
		}),
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.fixjson,
		null_ls.builtins.formatting.prettier.with({
			command = "node_modules/.bin/prettier"
		}),
	},
	on_attach = on_attach,
	-- This set the root_dir to the current dir
	root_dir = function() return nil end,
	debug = true,
})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
	pyright = {},
	gopls = {},
	rust_analyzer = {},
	sumneko_lua = {
		settings = {
			Lua = {
				runtime = {
					version = 'LuaJit',
				},
				diagnostics = {
					globals = { 'vim' },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = {
					enable = true
				}
			}
		}
	},
	tsserver = {
		init_options = {
			preferences = {
				disableSuggestions = true
			}
		}
	},
	volar = {
		filetypes = { 'vue' }
	}
}

require 'nvim-lsp-installer'.setup {}

for lsp, config in pairs(servers) do
	config.on_attach = on_attach
	config.handlers = handlers
	config.capabilities = capabilities

	require 'lspconfig'[lsp].setup(config)
end

require('git')

-- Tree sitter
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
			"#FAB2EA",
			"#65DEF1",
			"#F3CA40",
			"#FF88DC",
			"#C3D350",
			"#4CB944"
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

require 'color'

-- JSDoc generator
require 'neogen'.setup {}

-- Telescope
require 'telescope'.setup {
	file_ignore_patterns = { "node_modules" },
	layout_strategy = 'center',
	height = 0.9,
	layout_config = {
		preview_cutoff = 3,
		anchor = 'N'
	},
	mappings = {
		i = {
			["<Leader>q"] = require 'telescope.actions'.close
		},
		n = {
			["<Leader>q"] = require 'telescope.actions'.close
		}
	}
}

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

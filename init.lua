vim.cmd([[
call plug#begin()

Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'
Plug 'windwp/nvim-ts-autotag'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'markonm/traces.vim'

Plug 'marko-cerovac/material.nvim'
Plug 'projekt0n/github-nvim-theme'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

Plug 'Shatur/neovim-session-manager'
Plug 'goolord/alpha-nvim'


Plug 'mfussenegger/nvim-dap'

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

-- vim.cmd([[
-- 	if (has("termguicolors"))
-- 	  set termguicolors
-- 	endif
-- ]])

vim.g.mapleader = ' '

-- require 'github-theme'.setup {}
-- vim.cmd([[ colorscheme material]])
vim.cmd([[colorscheme catppuccin]])

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

-- General Keymaps
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>', { noremap = true })
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>', { noremap = true })
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>', { noremap = true })
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>', { noremap = true })
vim.keymap.set('n', '<Leader><Tab>', ':Telescope buffers<CR>', { noremap = true })
-- toggle uppercase
vim.keymap.set('n', '<Leader>uu', 'g~iw', { noremap = true })
vim.keymap.set('n', '<Leader>.', '10<C-w>>', { noremap = true })
vim.keymap.set('n', '<Leader>,', '10<C-w><', { noremap = true })

-- Auto comment
vim.keymap.set({ 'n', 'v' }, '<Leader>/', ':Commentary<CR>', { noremap = true })

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

-- Tree explorer
vim.keymap.set('n', '<C-N>', ':Lexplore<CR> :vertical <CR>', { noremap = true })

-- Setup lspconfig
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- LSP settings
local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
}

-- Mappings.
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>q', ':q<CR>', { noremap = true })
vim.keymap.set('n', '<space>w', ':w<CR>', { noremap = true })

-- Formatting
local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(clients)
			return vim.tbl_filter(function(client)
				return client.name ~= "tsserver"
			end, clients)
		end,
		bufnr = bufnr,
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

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>k', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>rf', '<cmd>lua require"telescope.builtin".lsp_references({layout_strategy = "horizontal" })<CR>', opts)
end

-- Null lsp
require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.eslint.with({
			disabled_filetypes = { 'vue' },
			command = "node_modules/.bin/eslint"
		}),
		require("null-ls").builtins.diagnostics.eslint.with({
			disabled_filetypes = { 'vue' },
			command = "node_modules/.bin/eslint"
		}),
		require 'null-ls'.builtins.diagnostics.angularls,
		require("null-ls").builtins.formatting.gofmt,
		require("null-ls").builtins.formatting.fixjson,
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
	angularls = {},
	rust_analyzer = {},
	sumneko_lua = {
		settings = {
			Lua = {
				runtime = {
					version = 'LuaJit',
				},
				diagnostics = {
					globals = 'vim',
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

-- Gitsigns
require('gitsigns').setup {
	current_line_blame = true,
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', ']c', function()
			if vim.wo.diff then return ']c' end
			vim.schedule(function() gs.next_hunk() end)
			return '<Ignore>'
		end, { expr = true })

		map('n', '[c', function()
			if vim.wo.diff then return '[c' end
			vim.schedule(function() gs.prev_hunk() end)
			return '<Ignore>'
		end, { expr = true })

		-- Actions
		map({ 'n', 'v' }, '<space>hs', ':Gitsigns stage_hunk<CR>')
		map({ 'n', 'v' }, '<space>hr', ':Gitsigns reset_hunk<CR>')
		map('n', '<space>hS', gs.stage_buffer)
		map('n', '<space>hu', gs.undo_stage_hunk)
		map('n', '<space>hR', gs.reset_buffer)
		map('n', '<space>hp', gs.preview_hunk)
		map('n', '<space>hb', function() gs.blame_line { full = true } end)
		map('n', '<space>tb', gs.toggle_current_line_blame)
		map('n', '<space>hd', gs.diffthis)
		map('n', '<space>hD', function() gs.diffthis('~') end)
		map('n', '<space>td', gs.toggle_deleted)

		-- Text object
		map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
	end
}

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
			["<space>q"] = require 'telescope.actions'.close
		},
		n = {
			["<space>q"] = require 'telescope.actions'.close
		}
	}
}
vim.keymap.set('n', '<space>ff', ':Telescope find_files <CR>', { noremap = true })
vim.keymap.set('n', '<Space>fg', ':Telescope live_grep <CR>', { noremap = true })

-- Signs
local signs = {
	DiagnosticSignError = 'E',
	DiagnosticSignWarn = 'W',
	DiagnosticSignHint = 'H',
	DiagnosticSignInfo = 'I',
	DapBreakpoint = '[>',
	DapStopped = '*',
}

for type, icon in pairs(signs) do
	vim.fn.sign_define(type, { text = icon, texthl = type, numhl = type })
end

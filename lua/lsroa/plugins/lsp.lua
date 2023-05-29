local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- LSP settings
local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help),
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Formatting
local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client) return client.name ~= "tsserver" end,
		bufnr = bufnr,
		-- async = true,
	})
end

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

	vim.keymap.set('n', '<Leader>k', function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set('n', '<Leader>rn', function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set('n', '<Leader>e', function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set('n', '<Leader>a', ':CodeActionMenu<CR>', opts)
	vim.keymap.set('n', 'gd', function() require 'telescope.builtin'.lsp_definitions() end, opts)
	vim.keymap.set('n', '<Leader>rf', function()
		require "telescope.builtin".lsp_references({ layout_strategy = 'vertical' })
	end, opts)
end

-- Null lsp
local null_ls = require 'null-ls'

null_ls.setup({
	sources = {
		-- null_ls.builtins.formatting.eslint.with({
		-- 	disabled_filetypes = { 'vue' },
		-- 	command = "node_modules/.bin/eslint"
		-- }),
		null_ls.builtins.diagnostics.eslint_d.with({
			disabled_filetypes = { 'vue' },
		}),
		null_ls.builtins.formatting.gofmt,
		-- null_ls.builtins.formatting.dprint,
		null_ls.builtins.formatting.prettier.with({
			-- command = "node_modules/.bin/prettier",
			disabled_filetypes = { 'vue' },
		}),
	},
	on_attach = on_attach,
	-- This set the root_dir to the current dir
	-- root_dir = function() return nil end,
	debug = true,
})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
	gopls = {},
	gdscript = {},
	zls = {},
	-- csharp_ls = {},
	rust_analyzer = {
		imports = {
			granularity = {
				group = "module",
			},
			prefix = "self",
		},
		cargo = {
			buildScripts = {
				enable = true,
			},
		},
		procMacro = {
			enable = true
		},
	},
	-- pyright = {},
	lua_ls = {
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
}

require 'mason'.setup()
require 'mason-lspconfig'.setup()

for lsp, config in pairs(servers) do
	config.on_attach = on_attach
	config.handlers = handlers
	config.capabilities = capabilities

	require 'lspconfig'[lsp].setup(config)
end

return {
	'jose-elias-alvarez/null-ls.nvim',
	config = function()
		local null_ls = require 'null-ls'

		null_ls.setup({
			sources = {
				null_ls.builtins.diagnostics.eslint.with({
					disabled_filetypes = { 'vue' },
					-- command = "node_modules/.bin/eslint"
				}),
				null_ls.builtins.formatting.gofmt,
				null_ls.builtins.formatting.prettier.with({
					disabled_filetypes = { 'vue' },
				}),
			},
			on_attach = on_attach,
		})
	end
}

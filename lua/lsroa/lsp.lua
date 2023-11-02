-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
	vim.lsp.handlers.signature_help, {
		border = 'rounded',
		close_events = { "BufHidden", "InsertLeave" },
	})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		border = 'rounded',
	})

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

	if client.name == 'rust_analyzer' then
		vim.lsp.buf.inlay_hint(bufnr, true)
	end

	local opts = { noremap = true, silent = true }

	vim.keymap.set('n', '<Leader>k', function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set('n', '<Leader>rn', function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set('n', '<Leader>e', function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
	vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, opts)
	vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
	vim.keymap.set('n', 'gd', function() require 'telescope.builtin'.lsp_definitions() end, opts)
	vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', '<Leader>rf', vim.lsp.buf.references, opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
	gopls = {},
	gdscript = {},
	zls = {},
	eslint = {},
	-- csharp_ls = {},
	prismals = {},
	clangd = {},
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
					enable = false
				}
			}
		}
	},
	tsserver = {
		inlayHints = {
			includeInlayParameterNameHints = 'all',
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayVariableTypeHintsWhenTypeMatchesName = false,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
		init_options = {
			preferences = {
				disableSuggestions = true,
				importModuleSpecifierPreference = 'relative',
			}
		}
	},
}

require 'mason'.setup()
require 'mason-lspconfig'.setup()

for lsp, config in pairs(servers) do
	config.on_attach = on_attach
	config.capabilities = capabilities

	require 'lspconfig'[lsp].setup(config)
end

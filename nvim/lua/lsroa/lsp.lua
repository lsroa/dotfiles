vim.lsp.util.apply_text_document_edit = function(text_document_edit, index, offset_encoding)
  local text_document = text_document_edit.textDocument
  local bufnr = vim.uri_to_bufnr(text_document.uri)
  if offset_encoding == nil then
    vim.notify_once('apply_text_document_edit must be called with valid offset encoding', vim.log.levels.WARN)
  end

  vim.lsp.util.apply_text_edits(text_document_edit.edits, bufnr, offset_encoding)
end

local M = {}
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
M.capabilities = capabilities

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = 'rounded',
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

  local opts = { noremap = true, silent = true }

  vim.keymap.set('n', '<Leader>k', function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set('n', '<Leader>rn', function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set('n', '<Leader>e', function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set('n', '[e', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
  vim.keymap.set('n', ']e', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
  vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, opts)
  vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set('n', 'gd', function() require 'telescope.builtin'.lsp_definitions() end, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<Leader>rf', vim.lsp.buf.references, opts)
end

M.on_attach = on_attach

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches

local servers = {
  gopls = {},
  gdscript = {},
  eslint = {
    settings = {
      experimental = { useFlatConfig = false },
    },
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end
  },
  pyright = {},
  prismals = {},
  glsl_analyzer = {},
  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
    },
  },
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
          library = {
            vim.api.nvim_get_runtime_file("", true),
            "${3rd}/love2d/library"
          },
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
      }
    },
    commands = {
      OrganizeImports = {
        function()
          local params = {
            command = "_typescript.organizeImports",
            arguments = { vim.api.nvim_buf_get_name(0) },
            title = ""
          }
          vim.lsp.buf.execute_command(params)
        end
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

return M

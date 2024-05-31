local M = {}
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
M.capabilities = capabilities

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = 'rounded',
    close_events = { "BufHidden", "InsertLeave" },
  })

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = 'single',
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

-- local group = vim.api.nvim_create_augroup("__formatter__", {})
-- vim.api.nvim_create_autocmd("BufWritePre", { group = group, command = ":Format" })

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
  vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, opts)
  vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set('n', 'gd', function() require 'telescope.builtin'.lsp_definitions() end, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<Leader>rf', vim.lsp.buf.references, opts)
end

M.on_attach = on_attach

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--
--
local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'
if not configs.oxlint then
  configs.oxlint = {
    default_config = {
      cmd = { 'oxlint', '.' },
      root_dir = lspconfig.util.root_pattern('.git'),
      filetypes = { 'typescript', 'typescriptreact' },
    },
  }
end

local servers = {
  gopls = {},
  gdscript = {},
  zls = {},
  arduino_language_server = {
    cmd = {
      "arduino-language-server",
      "-cli-config",
      os.getenv("HOME") .. ".arduinoIDE/arduino-cli.yaml",
      "-fqbn",
      "esp32:esp32:esp32",
      "-cli",
      "/opt/homebrew/bin/arduino-cli",
      "-clangd",
      "/opt/homebrew/opt/llvm/bin/clangd",
    }
  },
  eslint = {},
  ruff_lsp = {},
  pyright = {},
  prismals = {},
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

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Formatting
local add_autocmd_lsp_formatting = function(bufnr, client)
  if client:supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          filter = function(client) return client.name ~= "tsserver" end,
          bufnr = bufnr,
        })
      end
    })
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { noremap = true, silent = true }
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.data.buf

    vim.keymap.set('n', '<Leader>k', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
    if client.name ~= "basedpyright" then
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    end
    vim.keymap.set('n', '[e', function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set('n', ']e', function() vim.diagnostic.jump({ count = 1 }) end, opts)
    vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<Leader>rf', vim.lsp.buf.references, opts)

    add_autocmd_lsp_formatting(bufnr, client)
  end
})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches

local servers = {
  eslint = {},
  tailwincss = {},
  ruff = {
    init_options = {
      configuration = os.getenv("HOME") .. "/.ruff.toml",
    },
  },
  cssls = {},
  angularls = {},
  pyrefly = {},
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
  ts_ls = {
    init_options = {
      preferences = {
        disableSuggestions = true,
        importModuleSpecifierPreference = 'non-relative',
      }
    },
    commands = {
      OrganizeImports = {
        function()
          vim.lsp.buf.execute_command({
            command = "_typescript.organizeImports",
            arguments = { vim.api.nvim_buf_get_name(0) },
            title = "Organize imports",
          })
        end
      }
    }
  },
}

require 'mason'.setup()

for lsp, config in pairs(servers) do
  config.capabilities = capabilities

  vim.lsp.enable(lsp)
  vim.lsp.config(lsp, config)
end

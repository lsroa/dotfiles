return {
  "catppuccin/nvim",
  name = "catppuccin",
  dependencies = {
    {
      'norcalli/nvim-colorizer.lua',
      name = "colorizer"
    }
  },
  config = function()
    vim.cmd([[
			set termguicolors
		]])

    require('catppuccin').setup {
      custom_highlights = {
        healthError = {
          link = "Normal"
        },
        NormalFloat = {
          bg = '#181825',
        },
        ["@error"] = {
          link = "Normal"
        },
        DiagnosticUnderlineError = {
          link = "Normal"
        },
        LspDiagnosticsVirtualTextError = {
          link = "Normal"
        },
        LspDiagnosticsDefaultError = {
          link = "Normal"
        },
        LspDiagnosticDefaultError = {
          link = "Normal"
        },
        LspDiagnosticsError = {
          link = "Normal"
        },
        DiagnosticVirtualTextError = {
          link = "Normal"
        },
        DiagnosticDefaultError = {
          link = "Normal"
        },
        LspDiagnosticError = {
          link = "Normal"
        },
        DiagnosticError = {
          link = "Normal"
        },
        DiffAdd = {
          bg = '#005f5f',
        },
        DiffDelete = {
          bg = '#875f5f'
        },
        DiffText = {
          bg = '#007f7f',
        },
        DiffChange = {
          bg = '#005f5f',
        },
        CursorLine = {
          bg = '#11111b',
        },
        LspInlayHint = {
          link = 'Comment'
        },
        GitSignsDeleteLn = {
          bg = '#875f5f'
        },
        DapBreakpoint = {
          fg = '#f7df1e'
        },
        WinSeparator = {
          fg = '#45475a',
          bg = 'None'
        },
        MatchParen = {
          fg = 'none',
          bg = '#525252',
        },
        Folded = {
          fg = '#45475a',
        },
        WinBar = {
          link = 'Comment',
        },
        NvimTreeGitModifiedIcon = {
          fg = "#f9e2af"
        },
        NvimTreeFolderName = {
          link = "Normal"
        },
        NvimTreeGitStagedIcon = {
          fg = "#a6e3a1"
        },
        NvimTreeOpenedHL = {
          link = "NvimTreeOpenedFile"
        },
        NvimTreeNormal = {
          bg = '#232325',
          fg = '#a6adc8',
        },
        NvimTreeOpenedFile = {
          bg = '#232325',
          fg = '#cad3f1',
          style = {
            'bold'
          }
        },
      },
      term_colors = true,
      transparent_background = true,
      integrations = {
        neotree = false,
        gitsigns = true,
        dap = true,
        treesitter = true,
        telescope = true,
      }
    }

    require 'colorizer'.setup()

    vim.cmd([[
			set termguicolors
			colorscheme catppuccin
		]])
  end
}

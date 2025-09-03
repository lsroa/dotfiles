return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
  },
  config = function()
    require 'nvim-treesitter.configs'.setup {
      highlight = {
        enable = true,
      },
      treesitter_context = {
        enable = true,
      },
    }
  end,
}

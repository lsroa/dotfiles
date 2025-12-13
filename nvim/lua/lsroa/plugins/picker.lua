return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = { "telescope", winopts = { preview = { default = "bat", layout = "vertical" } } },
  config = function()
    vim.keymap.set('n', '<Leader>ff', function()
      require("fzf-lua").combine({ pickers = "oldfiles,files", cwd = vim.fn.getcwd() })
    end)
  end
}

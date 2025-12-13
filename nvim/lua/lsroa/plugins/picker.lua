return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({
      "telescope",
      winopts = {
        preview = {
          vertical = "down:50%",
          layout = "vertical"
        }
      }
    })

    vim.keymap.set('n', '<Leader>ff', function()
      require("fzf-lua").combine({
        pickers = "oldfiles;files",
        cwd = vim.fn.getcwd(),
      })
    end)

    vim.keymap.set('n', '<Leader>fg', function()
      require("fzf-lua").live_grep({ cwd = vim.fn.getcwd() })
    end)

    vim.keymap.set('n', '<Leader>fs', function()
      require("fzf-lua").git_status({ pickers = "git_status", cwd = vim.fn.getcwd() })
    end)
  end
}

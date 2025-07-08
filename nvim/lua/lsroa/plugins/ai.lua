return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    config = function()
      require("codecompanion").setup({
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              show_result_in_chat = true, -- Show mcp tool results in chat
              make_vars = true,           -- Convert resources to #variables
              make_slash_commands = true, -- Add prompts as /slash commands
            }
          }
        },
        strategies = {
          chat = {
            adapter = "deepseek",
          },
          inline = {
            adapter = "deepseek",
          }
        },
        adapters = {
          deepseek = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "deepseek",
              env = {
                url = "http://localhost:52415",
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  default = "deepseek-coder-v2-lite",
                }
              },
            })
          end,
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup()
    end
  }
}

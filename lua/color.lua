-- require 'github-theme'.setup {}
-- vim.cmd([[ colorscheme material]])
-- local cp = require 'catppuccin.api.colors'.get_colors()
local cat = require 'catppuccin'
cat.setup {
	integrations = {
		neogit = true
	}
}
cat.remap({
	DiffAdd = {
		bg = '#244032'
	},
	DiffDelete = {
		bg = '#462c32'
	}
})

vim.cmd([[colorscheme catppuccin]])

-- local hl = function(group, opt)
-- 	vim.cmd(":hi clear " .. group)
-- 	vim.api.nvim_set_hl(0, group, opt)
-- end

vim.cmd([[
	if (has("termguicolors"))
 	  set termguicolors
 	endif
]])

local cp = require 'catppuccin.api.colors'.get_colors()
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
	},
	DiffText = {
		fg = cp.green,
		bg = '#238636',
	},
	DiffChange = {
		bg = '#244032',
	}

})
require 'colorizer'.setup()

vim.cmd([[colorscheme catppuccin]])

-- local hl = function(group, opt)
-- 	vim.cmd(":hi clear " .. group)
-- 	vim.api.nvim_set_hl(0, group, opt)
-- end

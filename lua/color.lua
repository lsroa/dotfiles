-- require 'github-theme'.setup {}
-- vim.cmd([[ colorscheme material]])
vim.cmd([[colorscheme catppuccin]])

local hl = function(group, opt)
	vim.cmd(":hi clear " .. group)
	vim.api.nvim_set_hl(0, group, opt)
end

-- hl("goTSType", {
-- 	fg = 'orange'
-- })

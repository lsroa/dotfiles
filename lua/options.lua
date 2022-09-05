-- Explorer
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_preview = 1

vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.signcolumn = 'yes'

vim.o.scrolloff = 8
vim.o.wrap = false

vim.cmd([[set splitright]])
vim.cmd([[set splitbelow]])

vim.o.incsearch = true
vim.o.hlsearch = false
vim.o.hidden = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.o.mouse = 'a'

-- Spaces and Tabs
vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.o.laststatus = 3
vim.o.winbar = [[ %=%m %f ]]

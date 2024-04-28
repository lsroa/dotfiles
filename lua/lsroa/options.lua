-- Explorer
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25
-- vim.g.netrw_preview = 1

vim.wo.relativenumber = false
vim.wo.number = true
vim.wo.signcolumn = 'yes'
vim.wo.cursorline = true

vim.o.scrolloff = 8
vim.o.wrap = false

vim.o.exrc = true
vim.cmd([[set splitright]])
vim.cmd([[set splitbelow]])
vim.cmd([[set clipboard+=unnamedplus]])

vim.o.guicursor = 'a:blinkon1,i:ver25'

vim.o.incsearch = true
vim.o.hlsearch = false
vim.o.hidden = true
vim.o.mouse = 'a'
vim.o.ruler = false
vim.o.showmode = false
vim.o.showcmd = false
vim.o.laststatus = 0

-- Fold
vim.opt.foldmethod = "indent"
vim.opt.fillchars = { eob = "-", fold = " ", foldclose = ">" }
vim.opt.listchars = { tab = "⇥ ", trail = "·" }
vim.opt.list = true
vim.cmd("set foldlevel=9")


vim.o.winbar = [[ %=%m %f ]]
vim.o.sessionoptions = "blank,buffers,curdir,winsize,winpos,terminal"

vim.o.swapfile = false

-- General Keymaps
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>', { noremap = true })
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>', { noremap = true })
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>', { noremap = true })
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>', { noremap = true })
-- toggle uppercase
vim.keymap.set('n', '<Leader>uu', 'g~iw', { noremap = true })
vim.keymap.set('n', '<Leader>.', '10<C-w>>', { noremap = true })
vim.keymap.set('n', '<Leader>,', '10<C-w><', { noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
vim.keymap.set('n', "<Leader>'", ':vs<CR>', { noremap = true })
vim.keymap.set('n', "<Leader>s", ':sp<CR>', { noremap = true })
-- Auto comment
vim.keymap.set({ 'n', 'v' }, '<Leader>/', ':Commentary<CR>', { noremap = true })

-- Tree explorer
vim.keymap.set('n', '<C-n>', ':NeoTreeShowToggle<CR>', { noremap = true })

vim.keymap.set('n', '<Leader>gg', ':Neogit <CR>', { noremap = true })

vim.keymap.set('n', '<Leader>q', ':q<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true })

vim.keymap.set('n', '<Leader>ff', ':Telescope find_files <CR>', { noremap = true })
vim.keymap.set('n', '<Leader>fg', ':Telescope live_grep <CR>', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('n', '<Leader>fh', ':Telescope help_tags<CR>', { noremap = true })

-- Commands
vim.api.nvim_create_user_command("LspLog", "e $HOME/.cache/nvim/lsp.log", {})

vim.api.nvim_create_user_command("Neotest", function()
	require('neotest').run.run()
end, {})

vim.api.nvim_create_user_command("NeotestOpen", function()
	require('neotest').output.open({ enter = true })
end, {})

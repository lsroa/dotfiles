-- General Keymaps
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('n', '<c-h>', ':TmuxNavigateLeft<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-j>', ':TmuxNavigateDown<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-k>', ':TmuxNavigateUp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-l>', ':TmuxNavigateRight<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-w>j', ':wincmd -5<CR>', { noremap = true })
vim.keymap.set('n', '<c-w>k', ':wincmd +5<CR>', { noremap = true })
-- toggle uppercase
vim.keymap.set('n', '<Leader>uu', 'g~iw', { noremap = true })

vim.keymap.set('n', '<c-w>l', '5<C-w>>', { noremap = true })
vim.keymap.set('n', '<c-w>h', '5<C-w><', { noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
vim.keymap.set('n', "<Leader>S", ':vs<CR>', { noremap = true })
vim.keymap.set('n', "<Leader>s", ':sp<CR>', { noremap = true })
-- Auto comment
vim.keymap.set({ 'n', 'v' }, '<Leader>/', ':Commentary<CR>', { noremap = true })

-- Tree explorer
vim.keymap.set('n', '<C-n>', ':NeoTreeFocusToggle<CR>', { noremap = true })

vim.keymap.set('n', '<Leader>gg', ':Neogit <CR>', { noremap = true })

vim.keymap.set('n', '<Leader>q', ':q<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>;', ':', { noremap = true })

vim.keymap.set('n', ']t', ':tabnext<CR>', { noremap = true })
vim.keymap.set('n', '[t', ':tabprevious<CR>', { noremap = true })
vim.keymap.set({ 'n' }, '<Left>', '^', { noremap = true })
vim.keymap.set({ 'n' }, '<Right>', '$', { noremap = true })

vim.keymap.set('n', '<Leader>ff',
	function()
		require 'telescope.builtin'.find_files({
			find_command = { 'rg', '--files', '--hidden', '-g', '!.git', '-g', '!*.meta' }
		})
	end,
	{ noremap = true }
)
vim.keymap.set('n', '<Leader>fg', ':Telescope live_grep <CR>', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('n', '<Leader>fh', ':Telescope help_tags<CR>', { noremap = true })

-- Commands
vim.api.nvim_create_user_command("LspLog", "e $HOME/.cache/nvim/lsp.log", {})

vim.api.nvim_create_user_command("CopyPath",
	function()
		local branch = string.gsub(vim.fn.system("git rev-parse --abbrev-ref HEAD"), "%s", "")
		local base_path = string.gsub(vim.fn.system(" git rev-parse --show-toplevel "), "%s", "")

		local repo = string.gsub(vim.fn.system([[git config --get remote.origin.url | rg -o ":(.*)\.git" -r '$1']]), "%s", "")

		local file_path = string.sub(vim.fn.expand("%:p"), string.len(base_path) + 1)
		local line = vim.api.nvim_win_get_cursor(0)[1]

		local copy = "https://github.com/" ..
				repo .. "/blob" .. "/" .. branch .. file_path .. "#L" .. line

		vim.fn.setreg("+", copy)
	end, {})

vim.cmd([[
  inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
  inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
  inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
  inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>"
  inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"\<Left>"
  inoremap <expr> ` strpart(getline('.'), col('.')-1, 1) == "\`" ? "\<Right>" : "\`\`\<Left>"
]])

vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",
	callback = function()
		vim.cmd("wincmd =")
	end
})

vim.keymap.set('i', '(', '()<left>', { noremap = true })
vim.keymap.set('i', '[', '[]<left>', { noremap = true })
vim.keymap.set('i', '{', '{}<left>', { noremap = true })
vim.keymap.set('i', '{<CR>', '{<CR>}<ESC>O', { noremap = true })

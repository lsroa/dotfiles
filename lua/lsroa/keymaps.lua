local opts = { noremap = true, silent = true }
-- General Keymaps
vim.keymap.set('i', 'jk', '<Esc>', opts)
vim.keymap.set('t', 'jk', '<C-\\><C-n>', opts)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)
vim.keymap.set('n', '<c-h>', ':TmuxNavigateLeft<CR>', opts)
vim.keymap.set('n', '<c-j>', ':TmuxNavigateDown<CR>', opts)
vim.keymap.set('n', '<c-k>', ':TmuxNavigateUp<CR>', opts)
vim.keymap.set('n', '<c-l>', ':TmuxNavigateRight<CR>', opts)
vim.keymap.set('n', '<CR>', 'ciw', opts) -- toggle uppercase
vim.keymap.set('n', '<Leader>uu', 'g~iw', opts)

vim.keymap.set('n', '<F6>', function()
	local is_left = vim.api.nvim_win_get_position(0)[2] == 0
	if is_left then
		vim.cmd('vertical resize -5')
	else
		vim.cmd('vertical resize +5')
	end
end, opts)

vim.keymap.set('n', '<F7>', function()
	local is_top = vim.api.nvim_win_get_position(0)[1] == 0
	if is_top then
		vim.cmd('resize +5')
	else
		vim.cmd('resize -5')
	end
end, opts)

vim.keymap.set('n', '<F8>', function()
	local is_top = vim.api.nvim_win_get_position(0)[1] == 0
	if is_top then
		vim.cmd('resize -5')
	else
		vim.cmd('resize +5')
	end
end, opts)

vim.keymap.set('n', '<F9>', function()
	local is_left = vim.api.nvim_win_get_position(0)[2] == 0
	if is_left then
		vim.cmd('vertical resize +5')
	else
		vim.cmd('vertical resize -5')
	end
end, opts)

vim.keymap.set('n', '<c-w>l', '5<C-w>>', opts)
vim.keymap.set('n', '<c-w>h', '5<C-w><', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', "<Leader>S", ':vs<CR>', opts)
vim.keymap.set('n', "<Leader>s", ':sp<CR>', opts)
-- Auto comment
vim.keymap.set({ 'n', 'v' }, '<Leader>/', ':Commentary<CR>', opts)


vim.keymap.set('n', '<Leader>q', ':q<CR>', opts)
vim.keymap.set('n', '<Leader>w', ':silent w<CR>', opts)
vim.keymap.set({ 'n', 'v' }, '-', 'za<CR>', opts)

vim.keymap.set('n', ']t', ':tabnext<CR>', opts)
vim.keymap.set('n', '[t', ':tabprevious<CR>', opts)
vim.keymap.set({ 'n' }, '<Left>', '^', opts)
vim.keymap.set({ 'n' }, '<Right>', '$', opts)

vim.keymap.set('n', ']q', ':cnext<CR>', opts)
vim.keymap.set('n', '[q', ':cprevious<CR>', opts)

-- Dont yank on put
vim.keymap.set('x', 'p', '"_dP', opts)


vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('v', '<', '<gv', opts)

vim.keymap.set('n', '<Leader>tt', function()
	local file_path = vim.fn.expand("%:p:h")
	local file_name = string.gsub(string.gsub(string(vim.fn.expand("%:t")), ".ts$", ""), ".tsx$", "")
	for _, path in ipairs {
		file_path .. '/__test__/' .. file_name .. ".test.ts",
		file_path .. '/__test__/' .. file_name .. ".test.tsx",
		file_path .. '/__tests__/' .. file_name .. ".test.ts",
		file_path .. '/__tests__/' .. file_name .. ".test.tsx",
		file_path .. '/' .. file_name .. ".test.ts",
		file_path .. '/' .. file_name .. ".test.tsx",
		file_path .. '/__test__/' .. file_name .. ".spec.tsx",
		file_path .. '/__test__/' .. file_name .. ".spec.ts",
	} do
		print(path)
		if vim.fn.filereadable(path) == 1 then
			if vim.fn.winwidth(0) < 150 then
				vim.cmd("split " .. path)
			else
				vim.cmd("vsplit " .. path)
			end
		end
	end
end, opts)


vim.keymap.set('n', '<Leader>x', function()
	local file_path = vim.fn.expand("%:p")
	if vim.fn.winwidth(0) < 150 then
		vim.cmd("split")
	else
		vim.cmd("vsplit")
	end

	if vim.fn.filereadable(file_path) == 1 then
		vim.cmd("terminal npx jest " .. file_path)
	end
end, opts)

vim.keymap.set('n', '<Leader>g', function()
	os.execute("tmux split-window -h gg")
end, opts)

vim.keymap.set('n', '<Leader>tw', function()
	local file_path = vim.fn.expand("%:p")
	os.execute("tmux split-window -h " .. "npx jest --watch " .. file_path)
end, opts)


-- Commands
vim.api.nvim_create_user_command("LspLog", "e $HOME/.cache/nvim/lsp.log", {})

vim.api.nvim_create_user_command("SharePath",
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

vim.api.nvim_create_user_command("CopyPath", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
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

vim.keymap.set('i', '(', '()<left>', opts)
vim.keymap.set('i', '[', '[]<left>', opts)
vim.keymap.set('i', '{', '{}<left>', opts)
vim.keymap.set('i', '{<CR>', '{<CR>}<ESC>O', opts)

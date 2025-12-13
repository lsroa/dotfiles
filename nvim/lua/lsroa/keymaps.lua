local opts = { noremap = true, silent = true }
-- General Keymaps
vim.keymap.set('i', 'jk', '<Esc>', opts)
vim.keymap.set('t', 'jk', '<C-\\><C-n>', opts)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)
vim.keymap.set('n', '<c-h>', '<c-w>h', opts)
vim.keymap.set('n', '<c-j>', '<c-w>j', opts)
vim.keymap.set('n', '<c-k>', '<c-w>k', opts)
vim.keymap.set('n', '<c-l>', '<c-w>l', opts)
vim.keymap.set('n', '<Leader>F', ':Format<CR>', opts)

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
vim.keymap.set('n', '<Up>', '<C-u>zz', opts)
vim.keymap.set('n', '<Down>', '<C-d>zz', opts)
vim.keymap.set('n', "<Leader>S", ':vs<CR>', opts)
vim.keymap.set('n', "<Leader>s", ':sp<CR>', opts)
-- Auto comment
vim.keymap.set({ 'n', 'v' }, '<Leader>/', ':Commentary<CR>', opts)


vim.keymap.set('n', '<Leader>q', ':q<CR>', opts)
vim.keymap.set('n', '<Leader>w', ':silent w<CR>', opts)
vim.keymap.set('n', '<Leader>W', ':noautocmd w<CR>', opts)
vim.keymap.set({ 'n', 'v' }, '-', 'za<CR>', opts)

vim.keymap.set('n', ']t', ':tabnext<CR>', opts)
vim.keymap.set('n', '[t', ':tabprevious<CR>', opts)
vim.keymap.set({ 'n' }, '<Left>', '^', opts)
vim.keymap.set({ 'n' }, '<Right>', '$', opts)

vim.keymap.set('n', ']q', '<cmd>cnext<CR>', opts)
vim.keymap.set('n', '[q', '<cmd>cprevious<CR>', opts)

-- Dont yank on put
vim.keymap.set('x', 'p', '"_dP', opts)


vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('v', '<', '<gv', opts)

-- Commands
vim.api.nvim_create_user_command("LspLog", "e $HOME/.cache/nvim/lsp.log", {})

vim.api.nvim_create_user_command("SharePath",
  function()
    local branch = string.gsub(vim.fn.system("git rev-parse --abbrev-ref HEAD"), "%s", "")
    local base_path = string.gsub(vim.fn.system(" git rev-parse --show-toplevel "), "%s", "")

    local repo = string.gsub(vim.fn.system([[git config --get remote.origin.url | rg -o ":(.*)\.git" -r '$1']]), "%s", "")

    local file_path = string.sub(tostring(vim.fn.expand("%:p")), string.len(base_path) + 1)
    local line = vim.api.nvim_win_get_cursor(0)[1]

    local copy = "https://github.com/" ..
        repo .. "/blob" .. "/" .. branch .. file_path .. "#L" .. line

    vim.fn.setreg("+", copy)
  end, {})

vim.api.nvim_create_user_command("CopyPath", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
end, {})

vim.api.nvim_create_user_command("CopyRelativePath", function()
  local relative = vim.fn.expand("%:r")
  local ext = vim.fn.expand("%:e")
  local path = relative .. "." .. ext

  vim.fn.setreg("+", "@" .. path)
end, {})

vim.keymap.set("n", "<Leader>@", ":CopyRelativePath<CR>", { noremap = true })


vim.api.nvim_create_user_command("OpenPyCharm", function()
  local path = vim.fn.expand("%:p")
  vim.fn.system("open -a PyCharm " .. path)
end, {})

vim.api.nvim_create_user_command("OpenCursor", function()
  local path = vim.fn.expand("%:p")
  vim.fn.system("open -a cursor " .. path)
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

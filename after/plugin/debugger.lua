-- Debugger
local widgets = require 'dap.ui.widgets'
local sidebar = widgets.sidebar(widgets.scopes)
vim.fn.toggleDap = function()
	sidebar.toggle()
end

require("nvim-dap-virtual-text").setup()

vim.keymap.set('n', '<space>br', ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true })
vim.keymap.set('n', '<space>bc', ":lua require'dap'.set_breakpoint(vim.fn.input('Break condition: '))<CR>",
	{ noremap = true })
vim.keymap.set('n', '<space>ds', ":lua vim.fn.toggleDap()<CR>", { noremap = true })
vim.keymap.set('n', '<space>dk', ":lua require'dap.ui.widgets'.hover()<CR>", { noremap = true })
vim.keymap.set('n', '<space>dc', ":DapContinue <CR>", { noremap = true })

require 'dap-go'.setup()
local dap = require 'dap'
dap.adapters.node2 = {
	type = 'executable',
	command = 'node',
	args = {
		os.getenv('HOME') .. '/dev/vscode-node-debug2/out/src/nodeDebug.js' },
}

dap.configurations.javascript = {
	{
		name = 'Current file',
		type = 'node2',
		request = 'launch',
		program = '${file}',
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = 'inspector',
		console = 'integratedTerminal'
	},
	{
		-- For this to work you need to make sure the node process is started with the `--inspect` flag.
		name = 'Attach to process',
		type = 'node2',
		request = 'attach',
		processId = require 'dap.utils'.pick_process,
	}
}

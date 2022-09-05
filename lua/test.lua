require("neotest").setup({
	adapters = {
		require('neotest-jest')({
			jestCommand = "npm test --",
			jestConfigFile = "jest.config.js",
			env = { CI = true },
			cwd = function()
				return vim.fn.getcwd()
			end,
		}),
	},
	output = {
		enabled = true,
		open_on_run = true
	}
})

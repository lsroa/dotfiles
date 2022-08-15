require("neotest").setup({
	adapters = {
		require('neotest-jest')({
			jestCommand = "npm test --",
			jestConfigFile = "custom.jest.config.ts",
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

return {
	'nvim-tree/nvim-web-devicons',
	config = function()
		require 'nvim-web-devicons'.setup {
			strict = true,
			override_by_extension = {
				["test.ts"] = {
					icon = "",
					color = "#f0db4f",
					name = "TestTs",
				},
				["spec.ts"] = {
					icon = "",
					color = "#f0db4f",
					name = "SpecTs",
				},
				["test.tsx"] = {
					icon = "",
					color = "#f0db4f",
					name = "SpecTs",
				},
				["ts"] = {
					icon = "",
					color = "#519aba",
					name = "Ts",
				},
				["tsx"] = {
					icon = "",
					color = "#61DBFB",
					name = "Ts",
				},
				['gd'] = {
					icon = "",
					name = "GDScript",
					color = "#519aba",
				}
			},
		}
	end
}

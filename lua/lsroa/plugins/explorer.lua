return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-web-devicons" },
	config = function()
		local api = require('nvim-tree.api')
		local on_attach = function(bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "S", api.node.open.vertical, opts)
			vim.keymap.set("n", "s", api.node.open.horizontal, opts)
			vim.keymap.set("n", ".", api.tree.change_root_to_node, opts)
			vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts)
			vim.keymap.set("n", "<CR>", api.node.open.edit, opts)
			vim.keymap.set("n", ".", api.tree.change_root_to_node, opts)
			vim.keymap.set("n", "<BS>", api.tree.change_root_to_parent, opts)
			vim.keymap.set("n", "y", api.fs.copy.node, opts)
			vim.keymap.set("n", "p", api.fs.paste, opts)
			vim.keymap.set("n", "rn", api.fs.rename, opts)
			vim.keymap.set("n", "d", api.fs.remove, opts)
			vim.keymap.set("n", "a", api.fs.create, opts)
		end

		require('nvim-tree').setup({
			on_attach = on_attach,
			update_focused_file = {
				enable = true,
			},
			filters = { custom = { "^.git$", "^node_modules", "^.yarn" } },
			view = {
				width = {
					min = 30,
					max = -1,
				}
			},
			renderer = {
				icons = {
					git_placement = "after",
				},
				highlight_git = true,
				highlight_opened_files = "name",
				special_files = { "^." },
			},
			actions =
			{
				open_file = {
					window_picker = {
						enable = false
					}
				}
			},
		})

		local nvimTreeFocusOrToggle = function()
			local currentBuf = vim.api.nvim_get_current_buf()
			local currentBufFt = vim.api.nvim_get_option_value("filetype", { buf = currentBuf })
			if currentBufFt == "NvimTree" then
				api.tree.close()
			elseif api.tree.is_visible() then
				api.tree.focus()
			else
				api.tree.toggle({ find_file = true, focus = true, update_root = true })
			end
		end

		vim.keymap.set("n", "<C-n>", nvimTreeFocusOrToggle, { noremap = true, silent = true })
	end
}

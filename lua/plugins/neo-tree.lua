return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,
		keys = {
			{ "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
		},
		init = function()
			-- FIX: Close neo-tree before quitting to prevent session issues
			vim.api.nvim_create_autocmd("VimLeavePre", {
				command = "Neotree close",
			})
		end,
		opts = {
			close_if_last_window = true,
			enable_cursor_hijack = true,
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
				mappings = {
					["<C-]"] = "navigate_up",
					["<C-["] = "set_root",
				},
			},
			window = {
				width = 30,
				mappings = {
					["\\"] = "close_window",
				},
			},
			default_component_configs = {
				indent = { with_expanders = true },
				git_status = {
					symbols = {
						added = "✚", -- or "A",
						modified = "", -- or "M", (This is likely the one you want to change)
						renamed = "󰑕", -- or "R",
					},
				},
			},
		},
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	{
		"s1n7ax/nvim-window-picker",
		version = "2.*",
		config = function()
			require("window-picker").setup({
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						filetype = { "neo-tree", "neo-tree-popup", "notify" },
						-- if the buffer type is one of following, the window will be ignored
						buftype = { "terminal", "quickfix" },
					},
				},
			})
		end,
	},
}

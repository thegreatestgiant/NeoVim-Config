return {
	"AckslD/nvim-neoclip.lua",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		-- optional: persist clipboard history across sessions
		-- { "kkharji/sqlite.lua", module = "sqlite" },
	},
	event = "TextYankPost",
	config = function()
		require("neoclip").setup({
			history = 1000,
			enable_persistent_history = false, -- set to true + uncomment sqlite dep to persist across sessions
			length_limit = 1048576, -- 1MB max per entry
			continuous_sync = false,
			db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
			filter = nil,
			preview = true,
			prompt = nil,
			default_register = '"',
			default_register_macros = "q",
			enable_macro_history = true,
			content_spec_column = false,
			on_select = {
				move_to_front = false,
				close_telescope = true,
			},
			on_paste = {
				set_reg = false,
				move_to_front = false,
				close_telescope = true,
			},
			on_replay = {
				set_reg = false,
				move_to_front = false,
				close_telescope = true,
			},
			on_custom_action = {
				close_telescope = true,
			},
			keys = {
				telescope = {
					i = {
						select = "<CR>",
						paste = "<C-p>",
						paste_behind = "<C-k>",
						replay = "<C-q>",
						delete = "<C-d>",
						edit = "<C-e>",
						custom = {},
					},
					n = {
						select = "<CR>",
						paste = "p",
						paste_behind = "P",
						replay = "q",
						delete = "d",
						edit = "e",
						custom = {},
					},
				},
			},
		})

		require("telescope").load_extension("neoclip")
		require("core.utils").load_mappings("neoclip")
	end,
}

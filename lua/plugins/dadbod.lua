return {
	{
		"tpope/vim-dadbod",
		lazy = true, -- loaded on demand by the UI
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-completion",
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		init = function()
			-- Store connections outside the Neovim data dir so they persist
			vim.g.db_ui_save_location = vim.fn.expand("~/.local/share/db_ui")
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_execute_on_save = 0 -- don't auto-run queries on save
			vim.g.db_ui_win_position = "left"
			vim.g.db_ui_winwidth = 40
			-- Show query results in a horizontal split below the query buffer
			vim.g.db_ui_show_help = 0
		end,
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = { "tpope/vim-dadbod" },
		lazy = true, -- loaded by vim-dadbod-ui as a dependency
	},
}

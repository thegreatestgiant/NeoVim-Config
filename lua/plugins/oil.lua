return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			default_file_explorer = false, -- Keep neo-tree as the default; oil is opt-in
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			watch_for_changes = true,
			keymaps = {
				["<C-s>"] = false, -- disable so global save mapping works
			},
			columns = {
				"icon",
				-- "permissions",
				-- "size",
				-- "mtime",
			},
			win_options = {
				wrap = false,
				signcolumn = "no",
				cursorcolumn = false,
				foldcolumn = "0",
				spell = false,
				list = false,
				conceallevel = 3,
				concealcursor = "nvic",
			},
			float = {
				padding = 2,
				max_width = 0.8,
				max_height = 0.8,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
			},
			preview_win = {
				update_on_cursor_moved = true,
				preview_method = "fast_scratch",
			},
			view_options = {
				show_hidden = true, -- Matches your neo-tree hide_dotfiles = false
				natural_order = "fast",
				sort = {
					{ "type", "asc" },
					{ "name", "asc" },
				},
			},
		})

		require("core.utils").load_mappings("oil")
	end,
}

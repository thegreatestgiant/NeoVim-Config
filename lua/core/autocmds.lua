-- Global Auto-Command to strip trailing ^M on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function()
		-- Save cursor position to restore later
		local cur_pos = vim.api.nvim_win_get_cursor(0)

		-- Search and replace ^M (\r) with nothing.
		-- 'e' flag prevents error message if pattern is not found
		vim.cmd("keepjumps silent! %s/\\r//ge")

		-- Restore cursor position
		vim.api.nvim_win_set_cursor(0, cur_pos)
	end,
})

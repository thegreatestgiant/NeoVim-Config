return {
	"stevearc/quicker.nvim",
	event = "FileType qf",
	---@module "quicker"
	---@type quicker.SetupOptions
	opts = {},
	config = function(_, opts)
		require("quicker").setup(opts)

		-- Enable relative line numbers for future quickfix windows
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "qf",
			callback = function()
				vim.wo.relativenumber = true
				vim.wo.number = true
			end,
		})

		-- The very first time the plugin loads, the autocmd misses the event.
		-- So we manually apply the settings to any currently open quickfix windows.
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].filetype == "qf" then
				vim.wo[win].relativenumber = true
				vim.wo[win].number = true
			end
		end
	end,
}

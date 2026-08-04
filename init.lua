require("core.options")
vim.env.SSH_AUTH_SOCK = (os.getenv("XDG_RUNTIME_DIR") or ("/run/user/" .. vim.fn.trim(vim.fn.system("id -u")))) .. "/rbw/ssh-agent-socket"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
require("core.utils").load_mappings("all_globals")

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

require("core.options")

-- 1. Setup Lazy.nvim (Plugin Manager)
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

-- 2. Load Plugins
require("lazy").setup({
	require("plugins.neo-tree"),
	require("plugins.treesitter"),
	require("plugins.vim-be-good"),
	require("plugins.colorscheme"),
	require("plugins.bufferline"),
	require("plugins.lualine"),
	require("plugins.indent-blankline"),
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.autocompletion"),
	require("plugins.none-ls"),
	require("plugins.gitsigns"),
	require("plugins.which"),
	require("plugins.notification"),
	require("plugins.notify"),
	require("plugins.todo"),
	require("plugins.mini"),
	require("plugins.misc"),
	require("plugins.dashboard"),
	require("plugins.sessions"),
	require("plugins.ufo"),
	require("plugins.jdtls"),
})

-- 3. Load Mappings (NOW SAFE to call after plugins)
-- This will now use which-key if it loaded successfully above,
-- or fallback to native keys if something went wrong.
require("core.utils").load_mappings("all_globals")

-- 4. Java Autocmds
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		-- Safety check: ensure plugin module exists before calling setup
		local ok, jdtls = pcall(require, "plugins.jdtls")
		if ok then
			jdtls.setup()
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "jdtls" then
			vim.schedule(function()
				vim.diagnostic.reset(client.id, args.buf)
			end)
		end
	end,
})

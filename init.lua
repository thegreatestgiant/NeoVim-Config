require("core.options")
require("core.mappings")

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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		require("plugins.jdtls").setup()
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "jdtls" then
			vim.schedule(function()
				vim.diagnostic.reset()
			end)
		end
	end,
})

-- Setup lazy.nvim
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
	-- require("plugins.java"),
	require("plugins.ufo"),
	require("plugins.lazy-dev"),
	require("plugins.jdtls"),
})

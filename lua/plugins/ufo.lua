return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	opts = {}, -- Empty options, or add your specific settings
	config = function()
		-- Recommended settings from the nvim-ufo README for LSP or Treesitter folding
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
	end,
}

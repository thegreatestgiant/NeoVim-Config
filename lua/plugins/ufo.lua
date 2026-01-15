return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	opts = {}, -- Empty options, or add your specific settings
	config = function()
		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				-- Fallback to the 'indent' provider if treesitter isn't available
				return { "treesitter", "indent" }
			end,
		})
	end,
}

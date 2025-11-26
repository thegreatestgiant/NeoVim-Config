return {
	{
		"nvim-mini/mini.nvim",
		version = false,
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			require("mini.pairs").setup()
			require("mini.comment").setup({
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring()
						or vim.bo.commentstring
				end,
			})
			require("mini.move").setup()
			require("mini.bufremove").setup()
			require("mini.hipatterns").setup()
			-- require("mini.animate").setup({
			-- 	scroll = {
			-- 		enable = false,
			-- 	},
			-- })
			require("core.utils").load_mappings("bufremove")
		end,
	},
}

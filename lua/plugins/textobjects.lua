return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
			},
			move = {
				set_jumps = true,
			},
		})

		local move = require("nvim-treesitter-textobjects.move")
		vim.keymap.set("n", "]f", function()
			move.goto_next_start("@function.outer")
		end, { desc = "Next function start" })
		vim.keymap.set("n", "]c", function()
			move.goto_next_start("@class.outer")
		end, { desc = "Next class start" })
		vim.keymap.set("n", "[f", function()
			move.goto_previous_start("@function.outer")
		end, { desc = "Previous function start" })
		vim.keymap.set("n", "[c", function()
			move.goto_previous_start("@class.outer")
		end, { desc = "Previous class start" })
	end,
}

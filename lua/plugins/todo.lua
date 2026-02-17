return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		signs = true,
		keywords = {
			FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
			TODO = { icon = " ", color = "info" },
			HACK = { icon = " ", color = "warning" },
			WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
		},
		highlight = {
			before = "",
			keyword = "wide",
			after = "fg",
			pattern = [[.*<(KEYWORDS)\s*:]], -- Match TODO: with colon
			comments_only = true,
		},
		search = {
			command = "rg",
			args = {
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
			},
			-- This pattern is CRITICAL - it's what ripgrep uses to find TODOs
			-- The default requires a colon after TODO, like: TODO:
			-- But your comment has: "// TODO make sure..." (no colon!)
			-- This pattern will match both "TODO:" and "TODO " (with space)
			pattern = [[\b(KEYWORDS)\s*:?\s*]], -- Made colon optional with ?
		},
	},
	config = function(_, opts)
		require("todo-comments").setup(opts)
		require("core.utils").load_mappings("todo")
	end,
}

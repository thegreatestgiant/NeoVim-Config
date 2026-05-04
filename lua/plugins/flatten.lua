local M = {
	"willothy/flatten.nvim",
	-- CRITICAL: Flatten must load immediately to intercept the terminal.
	-- We use lazy = false and a high priority so it loads before ToggleTerm.
	lazy = false,
	priority = 1001,
}

function M.config()
	require("flatten").setup({
		window = {
			-- "alternate" opens the git commit message in your main Neovim window
			-- instead of inside the tiny terminal popup.
			open = "alternate",
		},
		callbacks = {
			-- This is a nice quality-of-life feature for your workflow:
			-- It automatically hides your ToggleTerm when the commit message opens,
			-- and re-opens the terminal when you save and close the commit!
			pre_open = function()
				require("toggleterm").toggle(0)
			end,
			post_open = function(_, _, _, is_blocking)
				-- Optional: Add logic here if needed
			end,
			block_end = function()
				require("toggleterm").toggle(0)
			end,
		},
	})
end

return M

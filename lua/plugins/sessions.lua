return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		-- We explicitly list what to save, but we leave out "terminal"
		options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
	},
}

return {
	{
		"folke/which-key.nvim",
		lazy = false, -- Load immediately so utils.lua can use 'wk.add'
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300 -- Faster timeout for the menu to appear
		end,
		opts = {
			delay = 0,
			icons = {
				-- If you have a Nerd Font, set to true. If not, set to false.
				mappings = true,
				keys = {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			-- Document existing key chains
			spec = {
				{ "<leader>b", group = "Buffers" }, -- Matches your <leader>b mappings
				{ "<leader>d", group = "Diagnostics" }, -- Matches <leader>d mappings
				{ "<leader>n", group = "Notifications/Noice" }, -- Matches <leader>n mappings
				{ "<leader>q", group = "Quit" }, -- Matches <leader>q mappings
				{ "<leader>s", group = "Save/Splits" }, -- Renamed from 'Search' to match reality
				{ "<leader>t", group = "Terminal/Todo" }, -- Matches <leader>t mappings
				{ "<leader>l", group = "LSP/Misc" },
			},
		},
	},
}

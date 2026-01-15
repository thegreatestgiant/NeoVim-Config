return {
	{
		"folke/which-key.nvim",
		lazy = false,
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = function()
			local wk = require("which-key")

			wk.setup({
				delay = 0,
				icons = {
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

				spec = {
					{ "<leader>g", group = "Git" },
					{ "<leader>l", group = "LSP" },
					{ "<leader>M", group = "Maven" },
					{ "<leader>n", group = "Noice/Notifications" },
					{ "<leader>q", group = "Quit" },
					{ "<leader>s", group = "Search (Telescope)" },
					{ "<leader>t", group = "Toggle" },
					{ "<leader>w", group = "Window/Write" },
				},
			})

			-- Load write mappings
			require("core.utils").load_mappings("write")
		end,
	},
}

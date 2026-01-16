return {
	{
		-- Tmux & split window navigation
		"christoomey/vim-tmux-navigator",
		lazy = false,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate left" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate down" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate up" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate right" },
		},
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm", "Lazygit" },
		opts = {
			direction = "float",
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			-- Define the custom Lazygit terminal
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				hidden = true,
				direction = "float",
				float_opts = {
					border = "rounded",
				},
				-- function to run on opening the terminal
				on_open = function(term)
					vim.cmd("startinsert!")
					-- Optional: Unmap <C-\> inside lazygit so it doesn't close the terminal immediately
					-- vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
				end,
				-- function to run on closing the terminal
				on_close = function(term)
					vim.cmd("startinsert!")
				end,
			})

			-- Create a Lua function to toggle it
			function _lazygit_toggle()
				lazygit:toggle()
			end

			-- Create a User Command ':Lazygit' that calls the function
			vim.api.nvim_create_user_command("Lazygit", function()
				_lazygit_toggle()
			end, {})
		end,
	},
	{
		"mbbill/undotree",
		config = function()
			require("core.utils").load_mappings("undotree")
		end,
	},
	{
		-- Detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
	},
	{
		-- GitHub integration for vim-fugitive
		"tpope/vim-rhubarb",
	},
	{
		-- High-performance color highlighter
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
}

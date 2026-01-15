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
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate previous" },
		},
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<c-\>]],
			direction = "float",
		},
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

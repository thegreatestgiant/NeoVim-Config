return {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},
	opts = {
		ensure_installed = {
			"lua",
			"python",
			"javascript",
			"typescript",
			"vimdoc",
			"vim",
			"regex",
			"sql",
			"dockerfile",
			"toml",
			"json",
			"java",
			"go",
			"gitignore",
			"c",
			"cpp",
			"yaml",
			"make",
			"cmake",
			"markdown",
			"markdown_inline",
			"bash",
			"css",
			"html",
		},
		auto_install = true,
		highlight = {
			enable = true,
			use_languagetree = true,
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true },
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)

		local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
		local configs = require("nvim-treesitter.configs")
		for name, fn in pairs(move) do
			if name:find("goto") == 1 then
				move[name] = function(q, ...)
					if vim.wo.diff then
						local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
						for key, query in pairs(config or {}) do
							if q == query and key:find("[%]%[][cC]") then
								vim.cmd("normal! " .. key)
								return
							end
						end
					end
					return fn(q, ...)
				end
			end
		end
	end,
	{
		"nvim-treesitter/nvim-treesitter-context",
		enabled = true,
		opts = { mode = "cursor", max_lines = 3 },
	},
}

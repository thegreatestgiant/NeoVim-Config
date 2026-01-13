return {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	branch = "main", -- explicit branch for the rewrite
	lazy = false,
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},
	config = function()
		local parsers = {
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
		}

		-- "force = false" ensures we don't reinstall existing parsers on every startup
		require("nvim-treesitter").install(parsers, { force = false })

		-- 2. Enable Features via Autocmd
		-- The new way to enable highlighting, indent, and folds
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				-- Enable syntax highlighting
				local ok, _ = pcall(vim.treesitter.start)

				-- Enable indentation (if supported by the language)
				if ok then
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

					-- Enable folding (optional, but standard)
					vim.wo.foldmethod = "expr"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				end
			end,
		})

		-- 3. Textobjects Move Patch
		-- Your custom logic to patch textobject movements.
		-- We wrap this in a pcall just in case the module location changes in textobjects plugin.
		local ok_move, move = pcall(require, "nvim-treesitter.textobjects.move")
		if ok_move then
			local configs = require("nvim-treesitter.configs") -- Note: textobjects might still need this shim, or it might be removed.
			-- If 'nvim-treesitter.configs' is truly gone, this part of your custom code might fail.
			-- However, since you are patching the function directly, we just need the 'move' module.

			for name, fn in pairs(move) do
				if name:find("goto") == 1 then
					move[name] = function(q, ...)
						if vim.wo.diff then
							-- NOTE: This logic relied on configs.get_module which might be gone.
							-- If this specific diff-mode check is critical, it may need a rewrite
							-- to check textobjects config directly, but for now we try/catch it.
							local success, config_mod = pcall(require, "nvim-treesitter.configs")
							if success then
								local config = config_mod.get_module("textobjects.move")[name]
								for key, query in pairs(config or {}) do
									if q == query and key:find("[%]%[][cC]") then
										vim.cmd("normal! " .. key)
										return
									end
								end
							end
						end
						return fn(q, ...)
					end
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

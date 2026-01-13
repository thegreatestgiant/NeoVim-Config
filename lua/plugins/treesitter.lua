return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main", -- explicit branch for the rewrite
	lazy = false,
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main", -- MUST be main to match treesitter rewrite
			lazy = true,
			config = function()
				-- 1. Setup Textobjects (Native Setup)
				-- The new textobjects setup does not use the .configs module
				require("nvim-treesitter.textobjects").setup({
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
							["]a"] = "@parameter.inner",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
							["]A"] = "@parameter.inner",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
							["[a"] = "@parameter.inner",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
							["[A"] = "@parameter.inner",
						},
					},
				})

				-- 2. Apply Diff-Mode Patch (Rewritten for 'main')
				-- We no longer look up 'configs'. We simply wrap the move module.
				local ok, move = pcall(require, "nvim-treesitter.textobjects.move")
				if ok then
					for name, fn in pairs(move) do
						if name:find("goto") == 1 then
							move[name] = function(q, ...)
								-- If we are in diff mode, and the movement is related to 'c' (change/class),
								-- we prioritize the native Vim diff jump.
								if vim.wo.diff then
									local key = vim.fn.getcharstr() -- optional: strictly check what key triggered this if needed
									-- Hardcoded check: If the intent was likely [c or ]c, perform native diff jump.
									-- Since we can't easily detect the *pressed* key inside this function without overhead,
									-- we assume if the user is in diff mode, they likely want standard behavior.

									-- Simple heuristic: Just run the native command if it's a class query
									if q == "@class.outer" then
										-- Check direction based on function name
										if name:find("next") then
											vim.cmd("normal! ]c")
										else
											vim.cmd("normal! [c")
										end
										return
									end
								end

								-- Otherwise, run the standard Treesitter movement
								return fn(q, ...)
							end
						end
					end
				end
			end,
		},
	},
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		-- 1. Setup Compiler (System Default)
		ts.setup({})

		-- 2. Define Parsers
		local desired_parsers = {
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

		-- 3. Robust Installation Logic
		-- Filters out already installed parsers to prevent crashes
		vim.schedule(function()
			local installed = ts.get_installed()
			local to_install = vim.tbl_filter(function(lang)
				return not vim.tbl_contains(installed, lang)
			end, desired_parsers)

			if #to_install > 0 then
				vim.notify("Installing " .. #to_install .. " new parsers...", vim.log.levels.INFO)
				ts.install(to_install, { force = false })
			end
		end)

		-- 4. Enable Highlights/Indent/Folds
		-- Using the new native Neovim method
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				local ok = pcall(vim.treesitter.start)
				if ok then
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.wo.foldmethod = "expr"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				end
			end,
		})
	end,
	{
		"nvim-treesitter/nvim-treesitter-context",
		enabled = true,
		opts = { max_lines = 3 },
	},
}

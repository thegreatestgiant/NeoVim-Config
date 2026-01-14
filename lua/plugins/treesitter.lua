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
		-- 1. Define the list of parsers you want
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
			"c",
			"cpp",
			"yaml",
			"markdown",
			"markdown_inline",
			"bash",
		}

		local function start_highlight(buf)
			local ft = vim.bo[buf].filetype
			-- Check if the parser for this filetype is in our list
			if vim.tbl_contains(parsers, ft) then
				-- Manually start the treesitter engine
				local ok = pcall(vim.treesitter.start, buf)
				if ok then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.wo.foldmethod = "expr"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				end
			end
		end

		-- 3. Install missing parsers manually
		local ts = require("nvim-treesitter")
		for _, lang in ipairs(parsers) do
			if not ts.get_parser_info(lang) then
				vim.cmd("TSInstallSync " .. lang)
			end
		end

		-- 4. Autocmd for FUTURE buffers
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				start_highlight(args.buf)
			end,
		})

		-- 5. Run immediately for the CURRENT buffer (Fixes your race condition)
		start_highlight(vim.api.nvim_get_current_buf())
	end,
	{
		"nvim-treesitter/nvim-treesitter-context",
		enabled = true,
		opts = { max_lines = 3 },
	},
}

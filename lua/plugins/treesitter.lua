return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
			lazy = true,
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			enabled = true,
			opts = { max_lines = 3 },
		},
	},
	build = ":TSUpdate",
	config = function()
		-- ========================================================================
		-- STEP 1: INSTALL PARSERS
		-- ========================================================================
		-- Define which languages you want syntax highlighting for
		local languages = {
			"bash",
			"c",
			"cpp",
			"dockerfile",
			"gitignore",
			"go",
			"html",
			"java",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"python",
			"regex",
			"toml",
			"vim",
			"vimdoc",
			"yaml",
		}

		-- Install the parsers (no-op if already installed)
		require("nvim-treesitter").install(languages)

		-- ========================================================================
		-- STEP 2: AUTO-ENABLE HIGHLIGHTING
		-- ========================================================================
		-- Map parser names to filetypes (most are 1:1, but "bash" → "sh")
		local filetypes = {
			"sh", -- bash parser
			"c",
			"cpp",
			"dockerfile",
			"gitignore",
			"go",
			"html",
			"java",
			"json",
			"lua",
			"markdown",
			"python",
			"vim",
			"toml",
			"yaml",
		}

		-- Create autocmd to enable highlighting when you open these file types
		local augroup = vim.api.nvim_create_augroup("TreesitterHighlighting", { clear = true })

		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			pattern = filetypes,
			callback = function(args)
				local bufnr = args.buf

				-- Start treesitter syntax highlighting
				local ok = pcall(vim.treesitter.start, bufnr)

				if ok then
					-- Enable treesitter-based code folding
					vim.wo.foldmethod = "expr"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

					-- Enable treesitter-based indentation
					vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})

		-- ========================================================================
		-- STEP 3: TEXTOBJECT NAVIGATION KEYMAPS
		-- ========================================================================
		-- Navigate between functions and classes with ]f, [f, ]c, [c
		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			pattern = filetypes,
			callback = function(args)
				local bufnr = args.buf
				local opts = { buffer = bufnr, silent = true }

				-- Jump to next/previous function
				vim.keymap.set("n", "]f", function()
					require("nvim-treesitter.textobjects.move").goto_next_start("@function.outer")
				end, vim.tbl_extend("force", opts, { desc = "Next function" }))

				vim.keymap.set("n", "[f", function()
					require("nvim-treesitter.textobjects.move").goto_previous_start("@function.outer")
				end, vim.tbl_extend("force", opts, { desc = "Previous function" }))

				-- Jump to next/previous class
				vim.keymap.set("n", "]c", function()
					require("nvim-treesitter.textobjects.move").goto_next_start("@class.outer")
				end, vim.tbl_extend("force", opts, { desc = "Next class" }))

				vim.keymap.set("n", "[c", function()
					require("nvim-treesitter.textobjects.move").goto_previous_start("@class.outer")
				end, vim.tbl_extend("force", opts, { desc = "Previous class" }))
			end,
		})

		-- ========================================================================
		-- STEP 4: FOLDING SETTINGS
		-- ========================================================================
		vim.o.foldcolumn = "1" -- Show fold column
		vim.o.foldlevel = 99 -- Open all folds by default
		vim.o.foldlevelstart = 99 -- Open all folds when opening a file
		vim.o.foldenable = true -- Enable folding
	end,
}

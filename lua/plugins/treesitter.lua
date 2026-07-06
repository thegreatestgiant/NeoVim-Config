return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,

	dependencies = {
		{
			"windwp/nvim-ts-autotag",
			event = "VeryLazy",
			config = function()
				require("nvim-ts-autotag").setup({
					opts = {
						enable_close = true,
						enable_rename = true,
						enable_close_on_slash = true,
					},
				})
			end,
		},
	},

	config = function()
		require("nvim-treesitter").setup({})

		local ensure_installed = {
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
			"sql",
			"toml",
			"typescript",
			"tsx",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		}

		require("nvim-treesitter").install(ensure_installed)

		-- Highlighting + indent are no longer setup() options on main branch;
		-- they're started per-buffer.
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local ft = vim.bo[args.buf].filetype
				local lang = vim.treesitter.language.get_lang(ft) or ft
				local ok = pcall(vim.treesitter.start, args.buf, lang)
				if ok then
					vim.bo[args.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
					if vim.bo[args.buf].indentexpr ~= "" then
						vim.opt_local.autoindent = true
					end
				end
			end,
		})

		-- Folding
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldcolumn = "1"
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		vim.opt.foldenable = true
	end,
}

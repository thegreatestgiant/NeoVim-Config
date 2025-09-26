return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim", -- ensure dependencies are installed
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting -- to setup formatters
		local diagnostics = null_ls.builtins.diagnostics -- to setup linters

		-- Formatters & linters for mason to install
		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier", -- ts/js formatter
				"shfmt", -- Shell formatter
				"stylua", -- lua formatter; Already installed via Mason
			},
			automatic_installation = true,
		})

		local sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.completion.spell,
			null_ls.builtins.code_actions.gitsigns,
			null_ls.builtins.code_actions.gomodifytags,
			null_ls.builtins.code_actions.impl,
			null_ls.builtins.completion.luasnip,
			null_ls.builtins.diagnostics.actionlint,
			null_ls.builtins.diagnostics.alex,
			null_ls.builtins.diagnostics.ansiblelint,
			null_ls.builtins.diagnostics.commitlint,
			null_ls.builtins.diagnostics.markdownlint,
			null_ls.builtins.diagnostics.mypy,
			null_ls.builtins.diagnostics.staticcheck,
			null_ls.builtins.diagnostics.yamllint,
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.gofmt,
			null_ls.builtins.formatting.gofumpt,
			null_ls.builtins.formatting.goimports,
			null_ls.builtins.formatting.goimports_reviser,
			null_ls.builtins.formatting.golines,
			null_ls.builtins.formatting.isort,
			null_ls.builtins.formatting.markdownlint,
			null_ls.builtins.formatting.prettier,
			diagnostics.checkmake,
			formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			formatting.terraform_fmt,
			require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			require("none-ls.formatting.ruff_format"),
		}

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		null_ls.setup({
			-- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
			sources = sources,
			-- you can reuse a shared lspconfig on_attach callback here
			on_attach = function(client, bufnr)
				if client:supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})
	end,
}

return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim",
	},

	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		--------------------------------------------------------------------------
		-- Mason integration (installs formatters + linters)
		--------------------------------------------------------------------------
		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier",
				"eslint_d",
				"commitlint", -- Add this!
				"yamllint",
				"shfmt",
				"clang_format",
				"alex",
				"markdownlint",
				"ruff",
				"gofumpt",
				"goimports",
				"staticcheck",
			},
			automatic_installation = true,
		})

		--------------------------------------------------------------------------
		-- Sources (your original list preserved)
		--------------------------------------------------------------------------
		local sources = {
			-- Lua
			formatting.stylua,

			-- Basic utilities
			null_ls.builtins.completion.spell,
			null_ls.builtins.code_actions.impl,
			null_ls.builtins.code_actions.gitsigns,
			null_ls.builtins.code_actions.gomodifytags,
			null_ls.builtins.completion.luasnip,

			-- Diagnostics
			diagnostics.actionlint,
			diagnostics.alex,
			diagnostics.ansiblelint,
			diagnostics.commitlint,
			diagnostics.markdownlint,
			diagnostics.staticcheck,
			diagnostics.yamllint,
			diagnostics.checkmake,

			-- Formatters
			formatting.gofumpt,
			formatting.goimports,
			formatting.markdownlint,
			formatting.prettier.with({
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"json",
					"yaml",
					"html",
					"css",
				},
			}),
			formatting.clang_format,
			formatting.shfmt.with({ args = { "-i", "4" } }),

			-- Ruff
			require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			require("none-ls.formatting.ruff_format"),
		}

		--------------------------------------------------------------------------
		-- Format on save (SAFE and cursor-preserving)
		--------------------------------------------------------------------------
		-- local format_group = vim.api.nvim_create_augroup("NullLsFormatOnSave", {})
		local format_group = vim.api.nvim_create_augroup("UnifiedFormatOnSave", { clear = true })

		local function setup_format_on_save(client, bufnr)
			-- Disable providing hover info
			client.server_capabilities.hoverProvider = false
			-- Only format if this client can format
			if not client:supports_method("textDocument/formatting") then
				return
			end

			vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = format_group,
				buffer = bufnr,
				callback = function()
					local can_format = false

					for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
						if c:supports_method("textDocument/formatting") then
							can_format = true
							break
						end
					end

					if not can_format then
						return
					end

					-- Save cursor + window position
					local view = vim.fn.winsaveview()

					vim.lsp.buf.format({
						async = false,
						filter = function(c)
							return c.name == "null-ls"
						end,
					})

					-- Restore cursor + window
					vim.fn.winrestview(view)
				end,
			})
		end
		--------------------------------------------------------------------------
		-- Setup null-ls
		--------------------------------------------------------------------------
		null_ls.setup({
			sources = sources,
			on_attach = setup_format_on_save,
		})
	end,
}

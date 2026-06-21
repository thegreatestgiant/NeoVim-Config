return {
	"nvimtools/none-ls.nvim",
	event = "LspAttach",
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
				"alex",
				"clang_format",
				"commitlint",
				"eslint_d",
				"prettier",
				"yamllint",
				"shfmt",
				"sql-formatter",
				"markdownlint",
				"ruff",
				"gofumpt",
				"goimports",
				"staticcheck",
				"json-repair",
			},
			automatic_installation = true,
		})

		local h = require("null-ls.helpers")

		local json_repair = h.make_builtin({
			name = "json_repair",
			meta = {
				url = "https://github.com/mangiucugna/json_repair",
				description = "Repairs malformed JSON (missing commas, quotes, brackets).",
			},
			method = null_ls.methods.FORMATTING,
			filetypes = { "json" },
			generator_opts = {
				command = "json_repair",
				args = { "$FILENAME" },
				to_stdin = false,
				from_stderr = false,
			},
			factory = h.formatter_factory,
		})

		--------------------------------------------------------------------------
		-- Sources (your original list preserved)
		--------------------------------------------------------------------------
		local sources = {
			formatting.prettier.with({
				filetypes = { "json" },
			}),

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
			diagnostics.checkmake,
			diagnostics.yamllint.with({
				extra_args = {
					"-d",
					"{extends: default, rules: {line-length: {max: 200}, comments: {min-spaces-from-content: 1}}}",
				},
			}),

			-- Formatters
			formatting.gofumpt,
			formatting.goimports,
			formatting.markdownlint,
			formatting.sql_formatter.with({
				extra_args = { "--config", '{"keywordCase": "upper", "dataTypeCase": "upper"}' },
			}),
			formatting.prettier.with({
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"html",
					"css",
				},
			}),

			formatting.prettier.with({
				filetypes = { "yaml" },
				extra_args = { "--print-width", "1000" },
			}),
			formatting.prettier.with({
				filetypes = { "json" },
			}),

			formatting.clang_format,
			formatting.shfmt.with({ args = { "-i", "4" } }),

			require("none-ls.formatting.eslint_d"),
			-- Ruff
			-- require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			-- require("none-ls.formatting.ruff_format"),
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

		vim.api.nvim_create_user_command("JsonRepair", function()
			if vim.bo.filetype ~= "json" then
				vim.notify("JsonRepair: not a JSON buffer", vim.log.levels.WARN)
				return
			end
			vim.lsp.buf.format({
				async = false,
				filter = function(c)
					return c.name == "null-ls"
				end,
			})
		end, { desc = "Repair malformed JSON in current buffer" })
		--------------------------------------------------------------------------
		-- Setup null-ls
		--------------------------------------------------------------------------
		vim.schedule(function()
			null_ls.setup({
				sources = sources,
				on_attach = setup_format_on_save,
			})
		end)
	end,
}

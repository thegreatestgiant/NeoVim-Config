return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants

		{ "mason-org/mason-lspconfig.nvim", opts = { automatic_enable = { exclude = { "jdtls" } } } },
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{
			"j-hui/fidget.nvim",
			opts = {
				notification = {
					window = {
						winblend = 0, -- Background color opacity in the notification window
					},
				},
			},
		},
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- LSP servers and clients are able to communicate to each other what features they support.
		-- By default, Neovim doesn't support everything that is in the LSP specification.
		-- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		-- So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		vim.diagnostic.config({
			float = { border = "rounded", source = "if_many", prefix = " " },
			-- Inline diagnostics
			virtual_text = {
				enabled = true,
				source = "if_many", -- Show source if multiple LSPs active
				prefix = "●", -- Icon before the message
				spacing = 4, -- Space between code and message
			},
			signs = true, -- Keep the gutter signs (W, E, etc)
			underline = true, -- Underline the problematic code
			update_in_insert = false, -- Don't update while typing
		})

		-- Show diagnostics in a floating window when cursor stops
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				vim.diagnostic.open_float(nil, {
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
					border = "rounded",
					source = "if_many",
					prefix = " ",
					scope = "cursor",
				})
			end,
		})

		-- Reduce the delay before showing (default is 4000ms)
		vim.opt.updatetime = 500 -- Show after 500ms of no movement

		-- Enable the following language servers
		--
		-- Add any additional override configuration in the following tables. Available keys are:
		-- - cmd (table): Override the default command used to start the server
		-- - filetypes (table): Override the default list of associated filetypes for the server
		-- - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		-- - settings (table): Override the default settings passed when initializing the server.
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
						format = {
							enable = false,
						},
					},
				},
			},
			pylsp = {
				settings = {
					pylsp = {
						plugins = {
							pyflakes = { enabled = false },
							pycodestyle = { enabled = false },
							autopep8 = { enabled = false },
							yapf = { enabled = false },
							mccabe = { enabled = false },
							pylsp_mypy = { enabled = false },
							pylsp_black = { enabled = false },
							pylsp_isort = { enabled = false },
						},
					},
				},
			},
		}

		-- Ensure the servers and tools above are installed
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
			"clangd",
			"clang-format",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		for server, cfg in pairs(servers) do
			-- For each LSP server (cfg), we merge:
			-- 1. A fresh empty table (to avoid mutating capabilities globally)
			-- 2. Your capabilities object with Neovim + cmp features
			-- 3. Any server-specific cfg.capabilities if defined in `servers`
			cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})

			vim.lsp.config(server, cfg)
			vim.lsp.enable(server)
		end
	end,
}

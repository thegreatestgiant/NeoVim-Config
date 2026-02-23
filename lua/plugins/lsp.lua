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
				require("core.utils").load_mappings("lsp")

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				-- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
				-- 	map("<leader>th", function()
				-- 		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				-- 	end, "[T]oggle Inlay [H]ints")
				-- end

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
				-- 1. Get all windows in the current tab
				local wins = vim.api.nvim_tabpage_list_wins(0)

				-- 2. Check if any existing window is a floating window
				for _, win in pairs(wins) do
					local config = vim.api.nvim_win_get_config(win)
					-- If a floating window (relative is not empty) is already open, return
					if config.relative ~= "" then
						return
					end
				end
				vim.diagnostic.open_float(nil, {
					-- focusable = false,
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
			pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace", -- Changed from openFilesOnly
							typeCheckingMode = "basic",
						},
					},
				},
			},
			ruff = {
				on_attach = function(client)
					client.server_capabilities.hoverProvider = false
				end,
			},
			clangd = {
				filetypes = { "c", "cpp", "objc", "objcpp" }, -- Ensure this is restrictive
			},
			gopls = {
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
					},
				},
			},
			vtsls = {
				filetypes = {
					"typescript",
					"typescriptreact",
					"javascript",
					"javascriptreact",
				},
				settings = {
					vtsls = {
						autoUseWorkspaceTsdk = true,
					},
					typescript = {
						suggest = {
							completeFunctionCalls = true,
						},
					},
				},
			},
			cssls = {},
			html = {},
		}

		-- Ensure the servers and tools above are installed
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua",
			"clangd",
			"clang-format",
			"pyright",
			"ruff",
			"gopls",
			"jdtls",
			"vtsls", -- Added this
			"eslint_d",
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

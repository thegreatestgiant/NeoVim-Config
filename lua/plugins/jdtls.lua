local M = {
	"mfussenegger/nvim-jdtls",
	lazy = true,
}

function M.setup()
	local jdtls = require("jdtls")

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	local function find_root()
		local cwd = vim.fn.getcwd()
		if vim.fn.isdirectory(cwd .. "/edu") == 1 then
			return cwd
		end
		local parent = vim.fn.fnamemodify(cwd, ":h")
		if vim.fn.isdirectory(parent .. "/edu") == 1 then
			return parent
		end
		return cwd
	end

	local root_dir = find_root()
	local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
	local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name
	local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

	local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"

	local jdtls_path = mason_packages .. "/jdtls"
	local java_debug_path = mason_packages .. "/java-debug-adapter"
	local java_test_path = mason_packages .. "/java-test"

	local launcher = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

	local bundles = {}

	local debug_jar = vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
	if debug_jar ~= "" then
		table.insert(bundles, debug_jar)
	end

	-- note: we use java_test_path variable we created above
	vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", true), "\n"))

	local cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		launcher,
		"-configuration",
		mason_path .. "/config_linux",
		"-data",
		workspace_dir,
	}

	local config = {
		cmd = cmd,
		root_dir = root_dir,
		capabilities = capabilities,
		settings = {
			java = {
				signatureHelp = { enabled = true },
				format = {
					settings = {
						url = vim.fn.expand("~/.config/nvim/java/eclipse-style.xml"),
						profile = "GoogleStyle",
					},
				},
			},
		},

		init_options = {
			bundles = bundles,
		},

		on_init = function(client, _)
			client.notify("workspace/didChangeConfiguration", {
				settings = {
					java = {
						project = {
							referencedLibraries = {},
							sourcePaths = {
								root_dir .. "/edu",
								root_dir .. "/ClassWork",
							},
						},
					},
				},
			})
		end,

		-- ATTACH DAP MAPPINGS AFTER START
		on_attach = function(client, bufnr)
			require("jdtls").setup_dap({ hotcodereplace = "auto" })
			require("core.utils").load_mappings("dap_java")
		end,
	}

	vim.lsp.handlers["workspace/executeClientCommand"] = function(_, res)
		return res or {}
	end

	vim.lsp.commands["java.apply.workspaceEdit"] = function(cmd)
		if cmd.arguments then
			vim.lsp.util.apply_workspace_edit(cmd.arguments[1], "utf-16")
		end
	end

	jdtls.start_or_attach(config)
end

return M

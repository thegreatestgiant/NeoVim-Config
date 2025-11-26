local M = {
	"mfussenegger/nvim-jdtls",
	lazy = true,
}

function M.setup()
	local jdtls = require("jdtls")

	--------------------------------------------------------------------
	-- ROOT DETECTION (correct + no hardcoding)
	--------------------------------------------------------------------
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

	--------------------------------------------------------------------
	-- WORKSPACE DIR
	--------------------------------------------------------------------
	local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
	local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

	--------------------------------------------------------------------
	-- MASON JDTLS
	--------------------------------------------------------------------
	local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
	local launcher = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

	--------------------------------------------------------------------
	-- COMMAND
	--------------------------------------------------------------------
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

	--------------------------------------------------------------------
	-- CONFIG
	--------------------------------------------------------------------
	local config = {
		cmd = cmd,
		root_dir = root_dir,
		settings = {
			java = {
				format = {
					settings = {
						url = vim.fn.expand("~/.config/nvim/java/eclipse-style.xml"),
						profile = "GoogleStyle",
					},
				},
			},
		},

		-- FIX: register proper source paths AFTER startup
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

		init_options = { bundles = {} },
	}

	--------------------------------------------------------------------
	-- FIX: stop RPC errors / workspace execute command spam
	--------------------------------------------------------------------
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

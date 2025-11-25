local M = {
	"mfussenegger/nvim-jdtls",
	lazy = true,
}

function M.setup()
	local jdtls = require("jdtls")

	-----------------------------------------------------------
	-- ROOT DETECTION (this is the fix)
	-----------------------------------------------------------
	local root_dir = require("jdtls.setup").find_root({
		"Intro To Comp Sci", -- your project root folder
		"edu", -- your actual Java root
	}) or vim.fn.getcwd()

	-----------------------------------------------------------
	-- WORKSPACE
	-----------------------------------------------------------
	local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
	local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

	-----------------------------------------------------------
	-- MASON JDTLS PATH
	-----------------------------------------------------------
	local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
	local launcher = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

	-----------------------------------------------------------
	-- COMMAND
	-----------------------------------------------------------
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

	-----------------------------------------------------------
	-- FIX: correct sourcePaths so imports resolve
	-----------------------------------------------------------
	local config = {
		cmd = cmd,
		root_dir = root_dir,
		settings = {
			java = {},
		},
		on_init = function(client, _)
			client.notify("workspace/didChangeConfiguration", {
				settings = {
					java = {
						project = {
							referencedLibraries = {},
							sourcePaths = {
								"/home/sean/Intro To Comp Sci/edu",
								"/home/sean/Intro To Comp Sci/ClassWork",
							},
						},
					},
				},
			})
		end,
		init_options = { bundles = {} },
	}

	-----------------------------------------------------------
	-- FIX: prevent RPC spam (workspace/executeClientCommand)
	-----------------------------------------------------------
	vim.lsp.commands["java.apply.workspaceEdit"] = function(cmd)
		if cmd.arguments then
			vim.lsp.util.apply_workspace_edit(cmd.arguments[1], "utf-16")
		end
		return {}
	end

	vim.lsp.handlers["workspace/executeClientCommand"] = function(_, result)
		return result or {}
	end

	-----------------------------------------------------------
	-- START JDTLS
	-----------------------------------------------------------
	jdtls.start_or_attach(config)
end

return M

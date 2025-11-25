local M = {
	"mfussenegger/nvim-jdtls",
	lazy = true,
}

function M.setup()
	local jdtls = require("jdtls")

	-- mason path
	local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
	local launcher = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

	-- root detection
	local root_markers = { "mvnw", "gradlew", "pom.xml", "build.gradle", ".git" }
	local root_dir = require("jdtls.setup").find_root(root_markers)
	if root_dir == "" then
		return
	end

	-- workspace
	local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
	local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

	-- silence unsupported command spam
	vim.lsp.commands["_java.reloadBundles.command"] = function() end

	-- command
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
		settings = { java = {
			format = {
				enabled = true,
			},
		} },
		init_options = { bundles = {} },
	}
	-- Global handler for Java client commands to prevent RPC errors
	vim.lsp.commands["java.apply.workspaceEdit"] = function(command)
		-- jdtls may send workspace edits via executeClientCommand
		if command.arguments then
			vim.lsp.util.apply_workspace_edit(command.arguments[1], "utf-16")
		end
		return {}
	end

	-- catch-all handler for "workspace/executeClientCommand"
	vim.lsp.handlers["workspace/executeClientCommand"] = function(_, result)
		return result or {}
	end

	jdtls.start_or_attach(config)
end

return M

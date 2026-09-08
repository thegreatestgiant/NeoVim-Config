return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
	local jdtls = require("jdtls")

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	local function find_root()
		local root = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", "mvnw", "gradlew", ".git" })
		if root then return root end

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

	-- Safely get the launcher jar (using vim.split in case multiple are matched)
	local launcher = vim.split(vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"), "\n")[1]

	local bundles = {}

	local debug_jar = vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
	if debug_jar ~= "" then
		vim.list_extend(bundles, vim.split(debug_jar, "\n"))
	end

	-- Load all java-test OSGi bundles (plugin + its runtime dependencies like junit4/5/6 runtime)
	-- but exclude the runner fat jar and jacocoagent which are not OSGi bundles
	local test_jars = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", true), "\n")
	for _, jar in ipairs(test_jars) do
		if jar ~= ""
			and not vim.endswith(jar, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
			and not vim.endswith(jar, "jacocoagent.jar")
		then
			bundles[#bundles + 1] = jar
		end
	end

	-- --- DYNAMIC JAVA 21 LSP RESOLUTION ---
	local java_cmd = "java" -- Default fallback to PATH

	local arch_java21 = "/usr/lib/jvm/java-21-openjdk/bin/java"
	local sdkman_java21 = vim.split(vim.fn.glob("~/.sdkman/candidates/java/21*/bin/java"), "\n")[1]

	-- Check which Java executable is actually present on this specific machine
	if vim.fn.executable(arch_java21) == 1 then
		java_cmd = arch_java21
	elseif sdkman_java21 and vim.fn.executable(sdkman_java21) == 1 then
		java_cmd = sdkman_java21
	end
	-- --------------------------------------

	-- --- DYNAMIC JAVA 17 RUNTIME FOR PROJECTS ---
	local java17_home = nil
	local arch_java17_home = "/usr/lib/jvm/java-17-openjdk"
	local sdkman_java17_home = vim.split(vim.fn.glob("~/.sdkman/candidates/java/17*/"), "\n")[1]

	if vim.fn.isdirectory(arch_java17_home) == 1 then
		java17_home = arch_java17_home
	elseif sdkman_java17_home and vim.fn.isdirectory(sdkman_java17_home) == 1 then
		java17_home = sdkman_java17_home
	end

	local runtimes = {}
	if java17_home then
		table.insert(runtimes, {
			name = "JavaSE-17",
			path = java17_home,
			default = true,
		})
	end
	
	-- Also register Java 21 so JDTLS knows about it natively
	local arch_java21_home = "/usr/lib/jvm/java-21-openjdk"
	if vim.fn.isdirectory(arch_java21_home) == 1 then
		table.insert(runtimes, {
			name = "JavaSE-21",
			path = arch_java21_home,
		})
	end
	-- --------------------------------------------

	local cmd = {
		java_cmd,
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
				configuration = {
					runtimes = #runtimes > 0 and runtimes or nil,
				},
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

	-- Attach to the current buffer (the one that triggered ft=java)
	jdtls.start_or_attach(config)

	-- Reset diagnostics on attach as we did in init.lua
	vim.schedule(function()
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.get_clients({ name = "jdtls", bufnr = bufnr })
		if #clients > 0 then
			vim.diagnostic.reset(clients[1].id, bufnr)
		end
	end)

	-- Also attach to every future Java buffer (config only runs once via lazy.nvim)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "java",
		callback = function()
			vim.b.sleuth_automatic = 0
			jdtls.start_or_attach(config)
		end,
	})
	end
}

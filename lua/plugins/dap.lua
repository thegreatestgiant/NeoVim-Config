return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"mason-org/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"mfussenegger/nvim-dap-python",
			"leoluz/nvim-dap-go",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local dappy = require("dap-python")
			local delve = require("dap-go")

			require("mason-nvim-dap").setup({
				automatic_installation = true,
				ensure_installed = {
					"python",
					"javadbg",
					"javatest",
					"delve",
					"codelldb",
				},
			})

			delve.setup()

			local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb_path,
					args = { "--port", "${port}" },
				},
			}
			dap.configurations.c = {
				{
					name = "Launch (codelldb)",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
			}
			dap.configurations.cpp = dap.configurations.c
			dap.configurations.asm = dap.configurations.c

			dapui.setup()

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			local debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			dappy.setup(debugpy_python)

			require("core.utils").load_mappings("dap")
			require("core.utils").load_mappings("dap_python")
		end,
	},
}

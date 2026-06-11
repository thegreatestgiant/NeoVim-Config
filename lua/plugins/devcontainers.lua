return {
	"https://codeberg.org/esensar/nvim-dev-container",
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = function()
		require("devcontainer").setup({
			container_runtime = "docker",
			compose_command = "docker-compose",

			attach_mounts = {
				neovim_config = {
					enabled = true,
					options = { "readonly" },
				},
				neovim_data = {
					enabled = false,
					options = {},
				},
				-- Only useful if using neovim 0.8.0+
				neovim_state = {
					enabled = false,
					options = {},
				},
			},

			terminal_handler = function(command)
				local laststatus = vim.o.laststatus
				vim.cmd("tabnew")
				local bufnr = vim.api.nvim_get_current_buf()
				vim.o.laststatus = 0
				local au_id = vim.api.nvim_create_augroup("devcontainer.docker.terminal", {})
				vim.api.nvim_create_autocmd("BufEnter", {
					buffer = bufnr,
					group = au_id,
					callback = function()
						vim.o.laststatus = 0
						vim.cmd("set lines+=1")
					end,
				})
				vim.api.nvim_create_autocmd("BufLeave", {
					buffer = bufnr,
					group = au_id,
					callback = function()
						vim.o.laststatus = laststatus
						vim.cmd("set lines-=1")
					end,
				})
				vim.api.nvim_create_autocmd("BufDelete", {
					buffer = bufnr,
					group = au_id,
					callback = function()
						vim.o.laststatus = laststatus
						vim.cmd("set lines-=1")
						vim.api.nvim_del_augroup_by_id(au_id)
					end,
				})
				vim.fn.termopen(command)
			end,
		})
		require("core.utils").load_mappings("dev")
	end,
}

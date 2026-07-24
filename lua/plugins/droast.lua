return {
	{
		-- Native Neovim diagnostics for the Droast Dockerfile linter
		"immanuwell/droast.nvim",
		ft = "dockerfile",
		opts = {
			on_save = true,
			virtual_text = true,
			signs = true,
			underline = true,
		},
	},
}

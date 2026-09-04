return {
	"oclay1st/maven.nvim",
	cmd = { "Maven", "MavenInit", "MavenExec", "MavenFavorites" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		projects_view = {
			custom_commands = {
				{
					name = "Clean Compile",
					cmd_args = { "clean", "compile" },
					description = "Cleans target and compiles project",
				},
				{
					name = "Run Tests",
					cmd_args = { "test" },
					description = "Runs all JUnit tests",
				},
				{
					name = "Package",
					cmd_args = { "package" },
					description = "Compiles and packages into a JAR",
				},
			},
		},
	},
}

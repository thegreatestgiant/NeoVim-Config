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
					name = "Run Demo",
					cmd_args = {
						"exec:java",
						"-Dexec.mainClass=edu.yu.cs.intro.hw7ShiurStats.Demo",
					},
					description = "Run Demo main class",
				},
			},
		},
	},
	keys = {
		{ "<leader>M", desc = "+Maven", mode = { "n", "v" } },
		{ "<leader>Mm", "<cmd>Maven<cr>", desc = "Maven Projects" },
		{ "<leader>Mf", "<cmd>MavenFavorites<cr>", desc = "Maven Favorite Commands" },
	},
}

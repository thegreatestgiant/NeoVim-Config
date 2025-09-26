return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			-- set an empty statusline till lualine loads
			vim.o.statusline = " "
		else
			-- hide the statusline on the starter page
			vim.o.laststatus = 0
		end
	end,
	config = function()
		local mode = {
			"mode",
			fmt = function(str)
				return " " .. str
				-- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
			end,
		}

		local filename = {
			"filename",
			file_status = true, -- displays file status (readonly status, modified status)
			path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
		}

		local filetype = {
			"filetype",
			icon_only = true,
			separator = "",
			padding = { left = 1, right = 0 },
		}

		local hide_in_width = function()
			return vim.fn.winwidth(0) > 100
		end

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			colored = false,
			update_in_insert = false,
			always_visible = false,
			cond = hide_in_width,
		}

		local diff = {
			"diff",
			colored = false,
			symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
			cond = hide_in_width,
		}

		vim.o.laststatus = vim.g.lualine_laststatus

		require("lualine").setup({
			options = {
				theme = "rose-pine", --"catppuccin",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { "branch" },
				lualine_c = { filetype, filename },
				lualine_x = { diagnostics, diff, { "encoding", cond = hide_in_width } },
				lualine_y = {
					{ "progress", padding = { left = 1, right = 1 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%-I:%02M %p")
					end,
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { { "location", padding = 0 } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "nvim-tree", "lazy" },
		})
	end,
}

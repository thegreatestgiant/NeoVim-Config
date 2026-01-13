local M = {}

---------------------------------------------------------------------
-- Sections to load at startup ("global" mappings)
---------------------------------------------------------------------
M._global_sections = {
	"general",
	"navigation",
	"window",
	"buffer",
	"diagnostic",
	"misc",
}

---------------------------------------------------------------------
-- GENERAL
---------------------------------------------------------------------
M.general = {
	n = {
		["<leader>"] = { "<Nop>", "Leader noop" },

		-- Save
		["<C-s>"] = { "<cmd>w<CR>", "Save file" },
		["<leader>sn"] = { "<cmd>noautocmd w<CR>", "Save without formatting" },

		-- Quit
		["<leader>qq"] = { "<cmd>q<CR>", "Quit" },
		["<leader>qa"] = { "<cmd>qa<CR>", "Quit all" },
	},

	i = {
		["<C-s>"] = { "<Esc><cmd>w<CR>", "Save file" },
		["jk"] = { "<Esc>", "Escape" },
		["jj"] = { "<Esc>", "Escape" },
	},

	v = {
		["<leader>"] = { "<Nop>", "Leader noop" },
	},
}

---------------------------------------------------------------------
-- NAVIGATION / MOVEMENT
---------------------------------------------------------------------
M.navigation = {
	n = {
		["J"] = { "mzJ`z", "Join lines and keep cursor" },

		["<C-d>"] = { "<C-d>zz", "Half page down centered" },
		["<C-u>"] = { "<C-u>zz", "Half page up centered" },

		["n"] = { "nzzzv", "Next search result centered" },
		["N"] = { "Nzzzv", "Prev search result centered" },
	},
}

---------------------------------------------------------------------
-- WINDOW MANAGEMENT
---------------------------------------------------------------------
M.window = {
	n = {
		-- Splits
		["<leader>v"] = { "<C-w>v", "Vertical split" },
		["<leader>h"] = { "<C-w>s", "Horizontal split" },
		["<leader>se"] = { "<C-w>=", "Equalize splits" },

		-- Navigate splits
		-- ["<C-k>"] = { "<C-w>k", "Go to upper split" },
		-- ["<C-j>"] = { "<C-w>j", "Go to lower split" },
		-- ["<C-h>"] = { "<C-w>h", "Go to left split" },
		-- ["<C-l>"] = { "<C-w>l", "Go to right split" },

		-- Resize splits
		["<Up>"] = { ":resize -2<CR>", "Resize -2 vertically" },
		["<Down>"] = { ":resize +2<CR>", "Resize +2 vertically" },
		["<Left>"] = { ":vertical resize -2<CR>", "Resize -2 horizontally" },
		["<Right>"] = { ":vertical resize +2<CR>", "Resize +2 horizontally" },
	},
}

---------------------------------------------------------------------
-- BUFFERS
---------------------------------------------------------------------
M.buffer = {
	n = {
		["<Tab>"] = { ":bnext<CR>", "Next buffer" },
		["<S-Tab>"] = { ":bprevious<CR>", "Previous buffer" },
		["<leader>b"] = { "<cmd>enew<CR>", "New buffer" },
	},
}

---------------------------------------------------------------------
-- DIAGNOSTICS
---------------------------------------------------------------------
M.diagnostic = {
	n = {
		["[d"] = {
			function()
				vim.diagnostic.jump({ count = -1, float = true })
			end,
			"Prev diagnostic",
		},

		["]d"] = {
			function()
				vim.diagnostic.jump({ count = 1, float = true })
			end,
			"Next diagnostic",
		},

		["<leader>d"] = { vim.diagnostic.open_float, "Float diagnostic" },
	},
}

---------------------------------------------------------------------
-- MISC
---------------------------------------------------------------------
M.misc = {
	n = {
		["<leader>lw"] = { "<cmd>set wrap!<CR>", "Toggle wrap" },

		["<leader>t"] = { "<cmd>ToggleTerm<CR>", "Toggle terminal" },
	},

	t = {
		["<leader>t"] = { "<cmd>ToggleTerm<CR>", "Toggle terminal" },
	},

	v = {
		["<"] = { "<gv", "Indent left stay selected" },
		[">"] = { ">gv", "Indent right stay selected" },
	},
}

---------------------------------------------------------------------
-- PLUGIN-SPECIFIC mappings (lazy loaded)
-- These are only loaded when utils.load_mappings("bufremove") etc. is called
---------------------------------------------------------------------
M.bufremove = {
	n = {
		["<leader>x"] = {
			function()
				local bd = require("mini.bufremove").delete
				if vim.bo.modified then
					local choice =
						vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&yes\n&no\n&cancel")
					if choice == 1 then
						vim.cmd.write()
						bd(0)
					elseif choice == 2 then
						bd(0, true)
					end
				else
					bd(0)
				end
			end,
			"Delete buffer",
		},
	},
}

M.todo = {
	n = {
		["<leader>ft"] = { "<cmd>TodoTelescope<CR>", "Todo via Telescope" },
		["]t"] = {
			function()
				require("todo-comments").jump_next()
			end,
			"Next todo",
		},
		["[t"] = {
			function()
				require("todo-comments").jump_prev()
			end,
			"Prev todo",
		},
	},
}

M.notify = {
	n = {
		["<leader>nd"] = {
			function()
				require("notify").dismiss({ pending = false })
			end,
			"Dismiss notifications",
		},
		["<leader>nh"] = { "<cmd>Telescope notify<CR>", "Notification history" },
	},
}

M.noice = {
	n = {
		["<leader>nl"] = { "<cmd>Noice last<CR>", "Noice last" },
		["<leader>nh"] = { "<cmd>Noice telescope<CR>", "Noice history" },
		["<leader>nd"] = { "<cmd>Noice dismiss<CR>", "Noice dismiss" },

		["<C-f>"] = {
			function()
				if not require("noice.lsp").scroll(4) then
					return "<C-f>"
				end
			end,
			"Scroll forward",
			expr = true,
		},

		["<C-b>"] = {
			function()
				if not require("noice.lsp").scroll(-4) then
					return "<C-b>"
				end
			end,
			"Scroll backward",
			expr = true,
		},
	},
}

return M

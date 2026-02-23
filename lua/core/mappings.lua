local M = {}

---------------------------------------------------------------------
-- Sections to load at startup ("global" mappings - non-plugin)
---------------------------------------------------------------------
M._global_sections = {
	"general",
	"navigation",
	"window",
	"buffer",
	"diagnostic",
	"misc",
	"maven",
	"terminal",
}

---------------------------------------------------------------------
-- GENERAL
---------------------------------------------------------------------
M.general = {
	n = {
		["<leader>"] = { "<Nop>", "Leader noop" },

		-- Save
		["<C-s>"] = { "<cmd>w<CR>", "Save file" },

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
		["<C-s>"] = { "<Esc><cmd>w<CR>", "Save file" },
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
		-- Splits (keep at root level for quick access)
		["<leader>v"] = { "<C-w>v", "Vertical split" },
		["<leader>h"] = { "<C-w>s", "Horizontal split" },

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

		["<leader>ld"] = { vim.diagnostic.open_float, "Show diagnostic" },
	},
}

---------------------------------------------------------------------
-- MISC
---------------------------------------------------------------------
M.misc = {
	n = {
		["<leader>tw"] = { "<cmd>set wrap!<CR>", "[T]oggle [w]rap" },
	},
	v = {
		["<"] = { "<gv", "Indent left stay selected" },
		[">"] = { ">gv", "Indent right stay selected" },
	},
}

---------------------------------------------------------------------
-- PLUGIN-SPECIFIC mappings (lazy loaded)
-- These are called from individual plugin configs
---------------------------------------------------------------------

-- Window/Write operations
M.write = {
	n = {
		["<leader>ww"] = { "<cmd>w<CR>", "Write/Save" },
		["<leader>wn"] = { "<cmd>noautocmd w<CR>", "Write without formatting" },
		["<leader>w="] = { "<C-w>=", "Equalize splits" },
	},
}

-- LSP mappings (buffer-local, called on LspAttach)
M.lsp = {
	n = {
		["desc"] = { "LSP: " },
		["<leader>la"] = {
			function()
				vim.lsp.buf.code_action()
			end,
			"Code [a]ction",
		},
		["<leader>lD"] = {
			function()
				require("telescope.builtin").lsp_type_definitions()
			end,
			"Type [D]efinition",
		},
		["<leader>lr"] = {
			function()
				vim.lsp.buf.rename()
			end,
			"[R]ename",
		},
		["<leader>ls"] = {
			function()
				require("telescope.builtin").lsp_document_symbols()
			end,
			"Document [s]ymbols",
		},
		["<leader>lS"] = {
			function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols()
			end,
			"Workspace [S]ymbols",
		},
		["<leader>lh"] = {
			function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
			end,
			"Toggle inlay [h]ints",
		},

		-- Standard LSP goto mappings (without leader)
		["gd"] = {
			function()
				require("telescope.builtin").lsp_definitions()
			end,
			"[G]oto [d]efinition",
		},
		["gr"] = {
			function()
				require("telescope.builtin").lsp_references()
			end,
			"[G]oto [r]eferences",
		},
		["gI"] = {
			function()
				require("telescope.builtin").lsp_implementations()
			end,
			"[G]oto [i]mplementation",
		},
		["gD"] = {
			function()
				vim.lsp.buf.declaration()
			end,
			"[G]oto [D]eclaration",
		},
		["K"] = {
			function()
				vim.lsp.buf.hover()
			end,
			"Hover documentation",
		},
		-- C-k is for signature help (shows function parameters)
		["<C-k>"] = {
			function()
				vim.lsp.buf.signature_help()
			end,
			"Signature help",
		},
	},

	x = {
		["<leader>la"] = {
			function()
				vim.lsp.buf.code_action()
			end,
			"Code [a]ction",
		},
	},

	v = {
		["<leader>la"] = {
			function()
				vim.lsp.buf.code_action()
			end,
			"Code [a]ction",
		},
	},
}

-- Buffer remove (mini.bufremove)
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

-- Todo comments
M.todo = {
	n = {
		["<leader>st"] = { "<cmd>TodoTelescope<CR>", "[S]earch [T]odos" },
		["]t"] = {
			function()
				require("todo-comments").jump_next()
			end,
			"Next Todo",
		},
		["[t"] = {
			function()
				require("todo-comments").jump_prev()
			end,
			"Previous Todo",
		},
	},
}

-- Noice
M.noice = {
	n = {
		["<leader>nl"] = { "<cmd>Noice last<CR>", "[N]oice [l]ast" },
		["<leader>nh"] = { "<cmd>Noice telescope<CR>", "[N]oice [h]istory" },
		["<leader>nd"] = { "<cmd>Noice dismiss<CR>", "[N]oice [d]ismiss" },

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

-- Gitsigns (called from gitsigns on_attach)
M.gitsigns = {
	n = {
		["]h"] = {
			function()
				require("gitsigns").next_hunk()
			end,
			"Next hunk",
		},
		["[h"] = {
			function()
				require("gitsigns").prev_hunk()
			end,
			"Prev hunk",
		},
		["<leader>gs"] = { ":Gitsigns stage_hunk<CR>", "Stage hunk" },
		["<leader>gr"] = { ":Gitsigns reset_hunk<CR>", "Reset hunk" },
		["<leader>gS"] = {
			function()
				require("gitsigns").stage_buffer()
			end,
			"Stage buffer",
		},
		["<leader>gu"] = {
			function()
				require("gitsigns").undo_stage_hunk()
			end,
			"Undo stage hunk",
		},
		["<leader>gR"] = {
			function()
				require("gitsigns").reset_buffer()
			end,
			"Reset buffer",
		},
		["<leader>gp"] = {
			function()
				require("gitsigns").preview_hunk_inline()
			end,
			"Preview hunk inline",
		},
		["<leader>gb"] = {
			function()
				require("gitsigns").blame_line({ full = true })
			end,
			"Blame line",
		},
		["<leader>gd"] = {
			function()
				require("gitsigns").diffthis()
			end,
			"Diff this",
		},
		["<leader>gD"] = {
			function()
				require("gitsigns").diffthis("~")
			end,
			"Diff this ~",
		},
		["<leader>tb"] = {
			function()
				require("gitsigns").toggle_current_line_blame()
			end,
			"[T]oggle git [b]lame",
		},
		["<leader>tw"] = {
			function()
				require("gitsigns").toggle_word_diff()
			end,
			"[T]oggle git [w]ord diff",
		},
	},
	v = {
		["<leader>gs"] = { ":Gitsigns stage_hunk<CR>", "Stage hunk" },
		["<leader>gr"] = { ":Gitsigns reset_hunk<CR>", "Reset hunk" },
	},
	o = {
		["ih"] = { ":<C-U>Gitsigns select_hunk<CR>", "GitSigns select hunk" },
	},
	x = {
		["ih"] = { ":<C-U>Gitsigns select_hunk<CR>", "GitSigns select hunk" },
	},
}

-- Telescope (called from telescope config)
M.telescope = {
	n = {
		["<leader>sh"] = {
			function()
				require("telescope.builtin").help_tags()
			end,
			"[S]earch [H]elp",
		},
		["<leader>sk"] = {
			function()
				require("telescope.builtin").keymaps()
			end,
			"[S]earch [K]eymaps",
		},
		["<leader>sf"] = {
			function()
				require("telescope.builtin").find_files()
			end,
			"[S]earch [F]iles",
		},
		["<leader>ss"] = {
			function()
				require("telescope.builtin").builtin()
			end,
			"[S]earch [S]elect telescope",
		},
		["<leader>sw"] = {
			function()
				require("telescope.builtin").grep_string()
			end,
			"[S]earch current [W]ord",
		},
		["<leader>sg"] = {
			function()
				require("telescope.builtin").live_grep()
			end,
			"[S]earch by [G]rep",
		},
		["<leader>sd"] = {
			function()
				require("telescope.builtin").diagnostics()
			end,
			"[S]earch [D]iagnostics",
		},
		["<leader>sr"] = {
			function()
				require("telescope.builtin").resume()
			end,
			"[S]earch [R]esume",
		},
		["<leader>s."] = {
			function()
				require("telescope.builtin").oldfiles()
			end,
			"[S]earch Recent Files ('.' for repeat)",
		},
		["<leader><leader>"] = {
			function()
				require("telescope.builtin").buffers()
			end,
			"[ ] Find existing buffers",
		},
		["<leader>/"] = {
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end,
			"[/] Fuzzy search in current buffer",
		},
		["<leader>s/"] = {
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			"[S]earch [/] in open files",
		},
	},
}

-- Undotree
M.undotree = {
	n = {
		["<leader>tu"] = { "<cmd>UndotreeToggle<cr>", "[T]oggle [u]ndotree" },
	},
}

-- Colorscheme (transparent)
M.colorscheme = {
	n = {
		["<leader>tt"] = { "<cmd>TransparentToggle<CR>", "[T]oggle [T]ransparency" },
	},
}

M.maven = {
	n = {
		["desc"] = { "Maven: " },

		["<leader>Mm"] = { "<cmd>Maven<cr>", "Projects" },
		["<leader>Mf"] = { "<cmd>MavenFavorites<cr>", "Favorite Commands" },
	},
}

M.terminal = {
	n = {
		["<leader>gg"] = { "<cmd>Lazygit<cr>", "Lazygit" },
		["<C-\\>"] = { "<cmd>ToggleTerm<cr>", "Toggle terminal" },
	},
	t = {
		-- Allow toggling out of terminal mode
		["<C-\\>"] = { "<cmd>ToggleTerm<cr>", "Toggle terminal" },
	},
}

-- Debug Adapter Protocol (DAP)
M.dap = {
	n = {
		["<leader>db"] = { "<cmd>DapToggleBreakpoint<CR>", "Toggle Breakpoint" },
		["<leader>dc"] = { "<cmd>DapContinue<CR>", "Continue" },
		["<leader>di"] = { "<cmd>DapStepInto<CR>", "Step Into" },
		["<leader>do"] = { "<cmd>DapStepOver<CR>", "Step Over" },
		["<leader>dO"] = { "<cmd>DapStepOut<CR>", "Step Out" },
		["<leader>dr"] = { "<cmd>DapToggleRepl<CR>", "Toggle REPL" },
		["<leader>dt"] = { "<cmd>DapTerminate<CR>", "Terminate" },
		["<leader>du"] = {
			function()
				require("dapui").toggle()
			end,
			"Toggle UI",
		},
	},
}

-- Python specific debug mappings
M.dap_python = {
	n = {
		["<leader>dpr"] = {
			function()
				require("dap-python").test_method()
			end,
			"Test Method (Python)",
		},
		["<leader>dpc"] = {
			function()
				require("dap-python").test_class()
			end,
			"Test Class (Python)",
		},
	},
}

M.dap_java = {
	n = {
		["<leader>djc"] = {
			function()
				require("jdtls").test_class()
			end,
			"Test Class (Java)",
		},
		["<leader>djm"] = {
			function()
				require("jdtls").test_nearest_method()
			end,
			"Test Method (Java)",
		},
		["<leader>djp"] = {
			function()
				require("jdtls.dap").pick_test()
			end,
			"Pick Test (Java)",
		},
	},
}

return M

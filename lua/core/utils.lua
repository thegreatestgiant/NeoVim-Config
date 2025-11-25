local M = {}
local wk = require("which-key")

M.load_mappings = function(plugin)
	plugin = plugin or "general"
	local M = {
		bufremove = {
			n = {
				["<leader>x"] = {
					function()
						local bd = require("mini.bufremove").delete
						if vim.bo.modified then
							local choice =
								vim.fn.confirm(("save changes to %q?"):format(vim.fn.bufname()), "&yes\n&no\n&cancel")
							if choice == 1 then -- yes
								vim.cmd.write()
								bd(0)
							elseif choice == 2 then -- no
								bd(0, true)
							end
						else
							bd(0)
						end
					end,
					"delete buffer",
				},
			},
		},

		todo = {
			n = {
				["<leader>ft"] = { "<cmd>TodoTelescope<CR>", "Todo via Telescope" },
				["]t"] = {
					function()
						require("todo-comments").jump_next()
					end,
					"Next Todo Comment",
				},
				["[t"] = {
					function()
						require("todo-comments").jump_prev()
					end,
					"Previous Todo Comment",
				},
			},
		},

		notify = {
			n = {
				["<leader>nd"] = {
					function()
						require("notify").dismiss({ pending = false })
					end,
					"[N]otify [D]ismiss",
				},
				["<leader>nh"] = { "<cmd>Telescope notify<CR>", "[N]otify [H]istory" },
			},
		},

		noice = {
			n = {
				["<leader>nl"] = { "<cmd>Noice last<CR>", "Noice Last Message" },
				["<leader>nh"] = { "<cmd>Noice telescope<CR>", "Noice History" },
				["<leader>nd"] = { "<cmd>Noice dismiss<CR>", "Dismiss All" },
				["<C-f>"] = {
					function()
						if not require("noice.lsp").scroll(4) then
							return "<C-f>"
						end
					end,
					"Scroll Forward",
					expr = true,
				},
				["<C-b>"] = {
					function()
						if not require("noice.lsp").scroll(-4) then
							return "<C-b>"
						end
					end,
					"Scroll Backward",
					expr = true,
				},
			},
		},
	}
	-- 🔧 Hybrid compiler (supports both old style and flat style)
	local mappings = {}

	for mode_or_map, value in pairs(M[plugin]) do
		if type(mode_or_map) == "string" and type(value) == "table" then
			-- 🟢 Old style: n = { ["lhs"] = { rhs, "desc" } }
			for lhs, rhs in pairs(value) do
				table.insert(mappings, {
					lhs,
					rhs[1],
					desc = rhs[2],
					mode = mode_or_map,
					expr = rhs.expr,
					silent = rhs.silent,
				})
			end
		elseif type(value) == "table" and value[1] then
			-- 🟢 New flat style: { "<lhs>", rhs, desc = "...", mode = "n" }
			table.insert(mappings, value)
		end
	end

	-- Register all mappings with new API (no deprecation warnings)
	for _, map in ipairs(mappings) do
		if not map.mode then
			map.mode = "n" -- default to normal mode if missing
		end
		wk.add(map)
	end
	-- local mmap = {}
	-- for key, value in pairs(M[plugin]) do
	-- 	if type(value) == "table" then
	-- 		mmap[#mmap + 1] = { value, key }
	-- 	end
	-- end
	-- for _, map in ipairs(mmap) do
	-- 	wk.register(map[1], { mode = map[2] })
	-- end
end

return M

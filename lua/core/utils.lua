local M = {}

M.load_mappings = function(section)
	local all = require("core.mappings")
	local maps = all[section]

	-- 1. Handle the special "all_globals" case (Recursion)
	if section == "all_globals" then
		for _, name in ipairs(all._global_sections) do
			M.load_mappings(name)
		end
		return
	end

	if not maps then
		return
	end

	-- 2. Check if which-key is currently available
	-- This allows us to use WhichKey features if loaded, but doesn't crash if not.
	local ok, wk = pcall(require, "which-key")

	-- 3. Loop through mappings
	for mode, mode_maps in pairs(maps) do
		for lhs, rhs in pairs(mode_maps) do
			local cmd = rhs[1]
			local desc = rhs[2]

			-- Prepare options for vim.keymap.set
			local opts = {
				desc = desc,
				expr = rhs.expr,
				silent = rhs.silent ~= false,
				noremap = true,
				nowait = rhs.nowait,
			}

			if ok then
				-- OPTION A: Use WhichKey (Best experience)
				-- This registers the key and the description for the menu
				wk.add({
					lhs,
					cmd,
					mode = mode,
					desc = desc,
					expr = opts.expr,
					silent = opts.silent,
				})
			else
				-- OPTION B: Fallback to Native Neovim (Safety Net)
				-- This ensures your keys work even if plugins are broken
				vim.keymap.set(mode, lhs, cmd, opts)
			end
		end
	end
end

return M

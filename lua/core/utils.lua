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
	local ok, wk = pcall(require, "which-key")

	-- 3. Loop through mappings
	for mode, mode_maps in pairs(maps) do
		-- Extract the prefix if the "desc" key exists in this mode block
		local prefix = ""
		if mode_maps["desc"] then
			prefix = mode_maps["desc"][1] or ""
		end

		for lhs, rhs in pairs(mode_maps) do
			-- IMPORTANT: Skip the "desc" key itself so we don't try to map it
			if lhs ~= "desc" then
				local cmd = rhs[1]

				-- Fix: Use '..' for string concatenation, not '+'
				-- Also handle cases where rhs[2] (description) might be nil
				local desc = prefix .. (rhs[2] or "")

				local opts = {
					desc = desc,
					expr = rhs.expr,
					silent = rhs.silent ~= false,
					noremap = true,
					nowait = rhs.nowait,
				}

				if ok then
					-- OPTION A: Use WhichKey (v3 Syntax)
					-- wk.add expects a list of mapping specifications
					wk.add({
						{
							lhs,
							cmd,
							mode = mode,
							desc = desc,
							expr = opts.expr,
							silent = opts.silent,
						},
					})
				else
					-- OPTION B: Fallback to Native Neovim
					vim.keymap.set(mode, lhs, cmd, opts)
				end
			end
		end
	end
end

return M

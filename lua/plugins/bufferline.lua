return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local bufferline = require("bufferline")
		bufferline.setup({
			options = {
				highlights = require("rose-pine.plugins.bufferline"),
				mode = "buffers", -- set to "tabs" to only show tabpages instead
				style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
				themable = true,
				numbers = "none", --| "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
				close_command = require("mini.bufremove").delete or "bdelete! %d",
				right_mouse_command = require("mini.bufremove").delete or "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
				left_mouse_command = require("mini.bufremove").delete or "buffer %d", -- can be a string | function, | false see "Mouse actions"
				middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
				indicator = {
					icon = "▎",
					style = "underline", --|'icon' | 'none',
				},
				buffer_close_icon = "󰅖",
				modified_icon = "● ",
				close_icon = " ",
				left_trunc_marker = " ",
				right_trunc_marker = " ",
				max_name_length = 30,
				max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
				truncate_names = false, -- whether or not tab names should be truncated
				tab_size = 21,
				diagnostics = false, -- | "nvim_lsp" | "coc",
				diagnostics_update_in_insert = false, -- only applies to coc
				diagnostics_update_on_event = true, -- use nvim's diagnostic handler
				offsets = {
					{
						filetype = "neo-tree",
						highlight = "Directory",
						text = "󰉓  File Explorer", -- | function ,
						text_align = "left", -- "center",-- |"left" | "right"
						separator = true,
					},
				},
				color_icons = true, -- | false, -- whether or not to add the filetype icon highlights
				show_buffer_icons = true, -- | false, -- disable filetype icons for buffers
				show_buffer_close_icons = true, --| false,
				show_close_icon = true, --| false,
				show_tab_indicators = false, --true ,
				show_duplicate_prefix = true, --| false, -- whether to show duplicate ,--buffer prefix
				duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
				persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
				move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
				-- can also be a table containing 2 custom separators
				-- [focused and unfocused]. eg: { '|', '|' }
				separator_style = { "│", "│" }, --"slant",-- | "slope" | "thick" | "thin" | { 'any', 'any' },
				enforce_regular_tabs = true, --false ,--| ,
				always_show_bufferline = true, --| false,
				auto_toggle_bufferline = true, --| false,
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				sort_by = "insert_at_end", -- 'insert_after_current', -- |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
				-- add custom logic
				--local modified_a = vim.fn.getftime(buffer_a.path)
				--local modified_b = vim.fn.getftime(buffer_b.path)
				--return modified_a > modified_b
				--end,
				pick = {
					alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
				},
			},
		})
	end,
}

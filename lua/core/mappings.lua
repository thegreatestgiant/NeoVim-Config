--vim.keymap.del('n', '<C-L>')
vim.keymap.del("n", "<C-l>")

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd> w <CR>", opts)

-- save file without auto-formatting
vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)

-- quit file
vim.keymap.set("n", "<leader>qq", "<cmd> q <CR>", opts)
vim.keymap.set("n", "<leader>qa", "<cmd> qa <CR>", opts)

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Resize with arrows
--vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
--vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
--vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
--vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
-- vim.keymap.set("n", "<leader>x", ":bdelete!<CR>", opts) -- close buffer
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height

-- Navigate between splits
vim.keymap.set("n", "<C-k>", "<C-w>k<CR>", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j<CR>", opts)
vim.keymap.set("n", "<C-h>", "<C-w>h<CR>", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l<CR>", opts)

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic message" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic message" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

-- Add Toggle Term Keymaps
vim.keymap.set("n", "<leader>t", "<cmd> ToggleTerm <CR>", opts)
vim.keymap.set("t", "<leader>t", "<cmd> ToggleTerm <CR>", opts)

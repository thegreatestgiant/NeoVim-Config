local g = vim.g

g.mapleader = " "
g.autoformat = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.cursorline = true
vim.o.autowrite = true
--vim.o.whichwrap = 'bs<>[]hl' -- Which "horizontal" keys are allowed to travel to prev/next line (default: 'b,s')
--vim.o.list = true
vim.o.shiftround = true
vim.o.signcolumn = "yes"
vim.o.smartcase = true
--vim.o.wrap = false -- Display lines as one long line (default: true)
--vim.o.linebreak = true

-- Indenting
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- disable netrw at the very start of your init.lua
--g.loaded_netrw = 1
--g.loaded_netrwPlugin = 1

vim.o.termguicolors = true
vim.opt.shortmess:append("c")
vim.opt.iskeyword:append("-")
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

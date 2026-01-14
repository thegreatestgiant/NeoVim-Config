# NeoVim Config

## Plugins

- neo-tree
- treesitter
- vim-be-good
- colorscheme
- bufferline
- lualine
- indent-blankline
- telescope
- lsp
- autocompletion
- none-ls
- gitsigns
- which
- notification
- notify
- todo
- mini
- misc
- dashboard
- vim-tmux-navigator
- toggleterm
- undotree
- vim-sleuth
- vim-fugitive
- vim-rhubarb
- nvim-colorizer
- sessions
- java
- ufo

## Required tools for this to work

- **Neovim** >= 0.10
- **Git**
- **C Compiler** (gcc, clang, or zig) - Required for `nvim-treesitter` and `telescope-fzf-native`
- **Make** - Required to build `telescope-fzf-native`
- **Node.js & npm** - Required for `tree-sitter-cli`, `prettier`, `alex`, `markdownlint`
- **tree-sitter-cli** - Required for `treesitter` installed with this command

```sh
npm install -g tree-sitter-cli neovim
```

- **Ripgrep** (`rg`) - Required for `telescope` live grep
- **Unzip** & **Tar** & **Curl** - Required by `mason.nvim` to install servers
- **JDK 17+** - Required for Java development (`jdtls`)
- **Nerd Font** - Required for icons in `neo-tree` and `lualine`

## How to use on your server

```git
git clone https://github.com/thegreatestgiant/NeoVim-Config.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

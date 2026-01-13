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

Neovim v.12

- tar
- curl
- [ tree-sitter-cli ](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md)

```sh
npm install -g tree-sitter-cli
```

- gcc (or any c compiler)

## How to use on your server

```git
git clone https://github.com/thegreatestgiant/NeoVim-Config.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

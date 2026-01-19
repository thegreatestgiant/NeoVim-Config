# NeoVim Config

## Plugins

### 🎨 UI & Themes

- **colorscheme** (Rose Pine, Nord, Dracula, TokyoNight, Oceanic Next)
- **lualine** (Status line)
- **bufferline** (Tab bar)
- **dashboard** (Start screen)
- **indent-blankline** (Indentation guides)
- **noice** (cmdline & notifications UI)
- **notify** (Notification manager)
- **nvim-colorizer** (Color highlighter)

### 🧭 Navigation

- **neo-tree** (File explorer)
- **telescope** (Fuzzy finder)
- **vim-tmux-navigator** (Seamless navigation between Nvim and Tmux)

### 💻 Coding & LSP

- **lsp** (Language Server Protocol)
- **autocompletion** (nvim-cmp + luasnip)
- **treesitter** (Syntax highlighting)
- **none-ls** (Formatting & Linting)
- **ufo** (Better folding)
- **todo-comments** (Highlight TODOs)
- **mini** (Surround, Pairs, Comment, etc.)

### 🐞 Debugging & Java

- **debugger** (nvim-dap + nvim-dap-ui + nvim-dap-python)
- **java** (nvim-jdtls)
- **maven** (Maven integration)

### 🌳 Git

- **gitsigns** (Git decorations)
- **vim-fugitive** (Git wrapper)
- **vim-rhubarb** (Github integration)

### 🛠️ Utilities

- **which-key** (Keybinding popup)
- **sessions** (Persistence)
- **undotree** (Undo history visualizer)
- **vim-sleuth** (Auto-detect indent settings)

## Required tools for this to work

- **Neovim** >= 0.10
- **Git**
- **C Compiler** (gcc, clang, or zig) - Required for `nvim-treesitter` and `telescope-fzf-native`
- **Make** - Required to build `telescope-fzf-native`
- **Node.js & npm** - Required for `tree-sitter-cli`, `prettier`, `alex`, `markdownlint`
- **Python 3** - Required for Python debugging (`debugpy`) and formatting
- **[Lazygit][lazygit-url]** - Required for `<leader>gg` mapping
- **Ripgrep** (`rg`) - Required for `telescope` live grep
- **Unzip** & **Tar** & **Curl** - Required by `mason.nvim` to install servers
- **JDK 17+** - Required for Java development (`jdtls`)
- **Nerd Font** - Required for icons in `neo-tree` and `lualine`
- **tree-sitter-cli** - Required for `treesitter` installed with this command

```sh
npm install -g tree-sitter-cli neovim
```

## How to use on your server

```git
git clone https://github.com/thegreatestgiant/NeoVim-Config.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

[lazygit-url]: https://github.com/jesseduffield/lazygit#installation

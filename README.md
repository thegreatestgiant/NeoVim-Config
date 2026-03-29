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

> **Tip:** If you don't want to install any of these, see the [Docker section](#docker) to run this config in a fully pre-configured container.

| Tool | Min Version | Why it's needed |
|---|---|---|
| **Neovim** | >= 0.10 | The editor itself |
| **Git** | any | Plugin management via `lazy.nvim` and `vim-fugitive` |
| **C Compiler** (gcc, clang, or zig) | any | Building `nvim-treesitter` parsers and `telescope-fzf-native` |
| **Make** | any | Building `telescope-fzf-native` |
| **Node.js & npm** | LTS | `tree-sitter-cli`, `prettier`, `alex`, `markdownlint` |
| **Python 3** | >= 3.8 | Python LSP (`pyright`), formatting (`ruff`), and debugging (`debugpy`) |
| **python3-venv** | any | Creates the isolated virtual environment that `debugpy` installs into |
| **Go** | >= 1.21 | Go LSP (`gopls`), formatting (`gofumpt`, `goimports`), and linting (`staticcheck`) |
| **[Lazygit][lazygit-url]** | any | The `<leader>gg` keymap launches a floating Lazygit terminal |
| **Ripgrep** (`rg`) | any | Powers `telescope` live grep (`<leader>sg`) |
| **Unzip, Tar, Curl, Wget** | any | Used by `mason.nvim` to download and unpack language servers and tools |
| **JDK 21+** | any | Java LSP (`jdtls`), debugging (`java-debug-adapter`, `java-test`) |
| **Nerd Font** | any | Icon rendering in `neo-tree`, `lualine`, `bufferline`, and `dashboard` |
| **tree-sitter-cli** | any | Compiling custom Tree-sitter grammars |

Install the Node.js globals with:
```sh
npm install -g tree-sitter-cli
```

## Docker & Automated Builds

The complete Neovim environment — all plugins, LSP servers, formatters, debuggers, and language runtimes — is packaged into a Docker image and automatically published to Docker Hub on every push via GitHub Actions.

**Docker Hub:** [hub.docker.com/u/thegreatestgiant](https://hub.docker.com/u/thegreatestgiant)

### How the automation works

The workflow in `.github/workflows/docker.yml` runs on every push and pull request. It builds the image from the `Dockerfile` in this repo and publishes it to `thegreatestgiant/nvim` with two tags: a pinned build number (e.g., `nvim:47`) for reproducibility, and `nvim:latest` for convenience. No manual build steps. No configuration drift.

### Jump in immediately (no local setup required)
```sh
# Pull the latest pre-built image
docker pull thegreatestgiant/nvim:latest

# Run with your current directory mounted
docker run -it --rm \
  -v "$(pwd)":/workspace \
  thegreatestgiant/nvim
```

Everything is already installed inside the image. The first time you open Neovim this way, it's ready to go — no `:MasonInstall`, no `:TSUpdate`, no plugin sync prompts.

## How to use on your server

```git
git clone https://github.com/thegreatestgiant/NeoVim-Config.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

[lazygit-url]: https://github.com/jesseduffield/lazygit#installation

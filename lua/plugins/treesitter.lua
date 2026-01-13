return {
  -- Main treesitter plugin
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        enabled = false,
        config = function()
          local move = require("nvim-treesitter.textobjects.move")
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name]
                  for key, query in pairs(config or {}) do
                    if q == query and key:find("[%]%[][cC]") then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
    },
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "bash",
        "c",
        "html",
        "css",
        "javascript",
        "typescript",
        "json",
        "yaml",
        "toml",
        "python",
        "java",
        "go",
        "sql",
        "dockerfile",
        "gitignore",
        "make",
        "cmake",
        "regex",
      },
      auto_install = true,
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      -- Safer loading with error handling
      local ok, treesitter = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("Treesitter failed to load", vim.log.levels.ERROR)
        return
      end
      treesitter.setup(opts)
    end,
  },

  -- Treesitter context (separate plugin)
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = true,
    opts = {
      mode = "cursor",
      max_lines = 3,
    },
  },
}

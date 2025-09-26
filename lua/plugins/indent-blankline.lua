return {
  "lukas-reineke/indent-blankline.nvim",
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
      hightlight = highlight,
    },
    scope = {
      show_start = false,
      show_end = false,
      show_exact_scope = false,
    },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "NvimTree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },
  main = "ibl",
}

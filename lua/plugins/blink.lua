return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
      ["<C-space>"] = { "show", "fallback" },
    },
    sources = {
      default = { "lsp", "buffer", "path" },
    },
  },
}

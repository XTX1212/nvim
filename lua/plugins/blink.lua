return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
      ["<CR>"] = {},
      ["<Tab>"] = {
        function(cmp)
          return cmp.select_and_accept()
        end,
        "snippet_forward",
        "fallback",
      },
      ["<C-space>"] = { "show", "fallback" }, 
    },
  },
}
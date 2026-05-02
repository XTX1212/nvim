return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      formatters = {
        clang-format = {
          command = "C:\\Program Files\\LLVM\\bin\\clang-format.exe",
        },
      },
    },
  },
}
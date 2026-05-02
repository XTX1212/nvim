return {
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_regenerate_on_save = false,
    },
    keys = {
      { "<leader>cG", "<cmd>CMakeGenerate<CR>", desc = "CMake Generate" },
      { "<leader>cB", "<cmd>CMakeBuild<CR>",    desc = "CMake Build" },
      { "<leader>cR", "<cmd>CMakeRun<CR>",      desc = "CMake Run" },
      { "<leader>cD", "<cmd>CMakeDebug<CR>",    desc = "CMake Debug" },
      { "<leader>cS", "<cmd>CMakeSelectBuildTarget<CR>", desc = "CMake Select Target" },
      { "<leader>cC", "<cmd>CMakeClean<CR>",    desc = "Clean Build Files" },
    },
  }
}
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          mason = false, -- 关键！阻止 mason-lspconfig 自动安装
          cmd = { "clangd" }, -- 直接使用系统 PATH 中的 clangd
          -- 你可以在这里添加其他 clangd 配置，比如 capabilities, on_attach 等
        },
      },
    },
  },
}

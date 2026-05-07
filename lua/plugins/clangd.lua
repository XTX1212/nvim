return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        -- 其他你想让 Mason 自动安装的服务器，比如 lua_ls, pyright
        -- 但是不要写 "clangd"
      },
      -- 关键：为 clangd 设置一个空的 hander，阻止 Mason 生成 cmd
      handlers = {
        clangd = function() end, -- 什么都不做，完全跳过
      },
    },
  },
}

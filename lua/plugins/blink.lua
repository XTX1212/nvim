return {
  -- 加载 blink.cmp 插件
  "saghen/blink.cmp",
  opts = {
    -- 设置键盘映射
    keymap = {
      -- 启用 super-tab 预设键位（Tab 选择下一个/确认补全）
      preset = "super-tab",
      -- 按 Ctrl+P 手动唤起补全菜单
      ["<C-p>"] = { "show", "fallback" },
    },
    -- 设置补全数据来源
    sources = {
      -- 依次使用 LSP、缓冲区文本、文件路径作为补全源
      default = { "lsp", "buffer", "path" },
    },
    -- 设置模糊匹配引擎
    fuzzy = {
      -- 使用 Lua 版模糊匹配实现
      implementation = "lua",
    },
  },
}

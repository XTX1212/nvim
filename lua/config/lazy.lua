-- lazy.nvim 安装路径
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 如果 lazy.nvim 不存在则克隆
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- 将 lazy.nvim 加入运行时路径
vim.opt.rtp:prepend(lazypath)

-- 插件配置
require("lazy").setup({
  spec = {
    -- 1. 导入 LazyVim 核心插件
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- 2. 导入 LazyVim 扩展（clangd 语言支持）
    { import = "lazyvim.plugins.extras.lang.clangd" },

    -- 3. 导入你自己的插件（位于 lua/plugins/ 目录下）
    { import = "plugins" },
  },
  defaults = {
    -- 自定义插件启动时加载（改为 true 会按需加载）
    lazy = false,
    -- 始终使用最新 git 提交（不固定版本）
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    -- 定期检查插件更新
    enabled = true,
    -- 检查时不弹出通知
    notify = false,
  },
  performance = {
    rtp = {
      -- 禁用一些内置插件以提升性能
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

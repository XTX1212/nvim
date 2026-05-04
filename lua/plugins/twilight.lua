return {
  "folke/twilight.nvim",
  lazy = false,
  opts = {},
  config = function(_, opts)
    require("twilight").setup(opts)

    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if vim.bo.buftype == "" and vim.bo.buftype ~= "nofile" then
          local filename = vim.api.nvim_buf_get_name(0)
          if filename and filename ~= "" then
            pcall(vim.cmd, "Twilight")
          end
        end
      end,
    })
  end,
  keys = {
    { "<leader>tt", "<cmd>Twilight<cr>", desc = "Toggle Twilight" },
  },
}

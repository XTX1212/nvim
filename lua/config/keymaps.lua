-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

-- 基础编辑与文件操作
keymap.set("i", "jk", "<ESC>")
keymap.set("n", "<leader>fp", ':let @+ = expand("%:p")<CR>', { desc = "Copy file path" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- 窗口管理
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })

-- 行移动 (Visual Mode)
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- ========== 调试相关快捷键 (nvim-dap) ==========
local dap = require("dap")
keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
keymap.set("n", "<C-F11>", dap.step_into, { desc = "Debug: Step Into" })
keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
keymap.set("n", "<leader>B", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
keymap.set("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Debug: Toggle UI" })

-- 清理调试进程 (Windows)
keymap.set("n", "<leader>dk", function()
  os.execute("taskkill /f /im main.exe")
  os.execute("taskkill /f /im codelldb.exe")
  local dapui = require("dapui")
  if dapui then
    dapui.close()
  end
  vim.notify("Killed debug processes & closed UI", "info", { title = "Debug" })
end, { desc = "Kill debug processes and close UI" })

local function insert_file_header()
    local filename = vim.fn.expand("%:t")
    local full_author = "Jiachen Xiong <9banwin@sina.com>"
    local name_only = "Jiachen Xiong"
    local date = os.date("%Y-%m-%d")
    local year = os.date("%Y")

    local header = 
        "/**\n" ..
        " * @file        " .. filename .. "\n" ..
        " * @brief       \n" ..
        " * @author      " .. full_author .. "\n" ..
        " * @date        " .. date .. "\n" ..
        " * @version     0.1.0\n" ..
        " * @copyright   Copyright (c) " .. year .. ", " .. name_only .. ". All rights reserved.\n" ..
        " */\n"

    local lines = vim.split(header, "\n")
    if lines[#lines] == "" then table.remove(lines) end

    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
    if not first_line:match("@file") then
        vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
        print("File header inserted.")
    else
        print("File header already exists.")
    end
end


-- 生成 Doxygen 函数注释（使用内置 vim.treesitter）
local function generate_function_doc()
    -- 获取光标所在的节点
    local node = vim.treesitter.get_node()
    if not node then
        print("No Tree-sitter node found. Try :TSInstall c")
        return
    end

    -- 向上查找函数定义节点 (function_definition)
    while node and node:type() ~= "function_definition" do
        node = node:parent()
    end
    if not node then
        print("Not on a function definition")
        return
    end

    -- 获取函数声明子节点 (function_declarator)
    local declarator = nil
    for child in node:iter_children() do
        if child:type() == "function_declarator" then
            declarator = child
            break
        end
    end
    if not declarator then
        print("Could not find function declarator")
        return
    end

    -- 提取参数名
    local params = {}
    for param in declarator:iter_children() do
        if param:type() == "parameter_list" then
            for p in param:iter_children() do
                if p:type() == "parameter_declaration" then
                    -- 参数声明中查找 identifier
                    for id in p:iter_children() do
                        if id:type() == "identifier" then
                            local name = vim.treesitter.get_node_text(id, 0)
                            table.insert(params, name)
                            break
                        end
                    end
                end
            end
            break
        end
    end

    -- 获取返回值类型（简单判断）
    local ret_type = nil
    for child in node:iter_children() do
        local typ = child:type()
        if typ == "primitive_type" or typ == "type_identifier" or typ == "qualified_identifier" then
            ret_type = vim.treesitter.get_node_text(child, 0)
            break
        end
    end

    -- 构建 Doxygen 注释
    local comment_lines = { "/**" }
    table.insert(comment_lines, " * @brief ")
    for _, p in ipairs(params) do
        table.insert(comment_lines, " * @param " .. p .. " ")
    end
    if ret_type and ret_type ~= "void" then
        table.insert(comment_lines, " * @return ")
    end
    table.insert(comment_lines, " */")

    -- 在函数定义前插入注释
    local start_row, _ = node:start()
    vim.api.nvim_buf_set_lines(0, start_row, start_row, false, comment_lines)

    -- 光标定位到 @brief 后面
    vim.api.nvim_win_set_cursor(0, { start_row + 1, 10 })
end

-- 绑定快捷键
vim.keymap.set("n", "<leader>nf", generate_function_doc, { desc = "Generate Doxygen function comment" })
vim.keymap.set("n", "<leader>fh", insert_file_header, { desc = "Insert Doxygen File Header" })
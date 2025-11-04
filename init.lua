--[[
Neovim 配置示例
注意事项：
1. 完整使用 mini.pick 需要安装 ripgrep，否则只能使用 git 查找。
   Windows 可通过 winget 安装：
     winget install BurntSushi.ripgrep.MSVC
   使用查找其他版本使用
     winget search ripgrep
2. 本配置使用 Neovim 0.12 内置 API（vim.pack）进行插件管理。
--]]

----------------------
-- 通用 Neovim 设置 --
----------------------
vim.opt.number = true                           -- 显示行号
vim.opt.relativenumber = true                   -- 显示相对行号
vim.opt.cursorline = true                       -- 高亮光标所在行
vim.opt.expandtab = true                        -- 使用空格代替 Tab
vim.opt.tabstop = 2                             -- Tab 键宽度为 2
vim.opt.shiftwidth = 2                          -- 缩进宽度为 2
vim.opt.wrap = false                            -- 不自动换行
vim.opt.scrolloff = 5                           -- 上下保留 5 行作为缓冲
vim.opt.signcolumn = 'yes'                      -- 永远显示 sign column（诊断标记）
-- vim.opt.winborder = 'rounded'                   -- 窗口边框样式
vim.opt.ignorecase = true                       -- 搜索忽略大小写
vim.opt.smartcase = true                        -- 当包含大写字母时，搜索区分大小写
vim.opt.hlsearch = false                        -- 搜索匹配不高亮
vim.opt.incsearch = true                        -- 增量搜索
vim.opt.foldmethod = 'expr'                     -- 折叠方式使用表达式
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()' -- 使用 Treesitter 表达式折叠
vim.opt.foldlevel = 99                          -- 打开文件时默认不折叠
vim.g.mapleader = ' '                           -- 设置 leader 键为空格

----------------------
-- 插件管理（vim.pack） --
----------------------
vim.pack.add({
  { src = 'https://github.com/morhetz/gruvbox' },       -- 主题
  { src = 'https://github.com/mason-org/mason.nvim' },  -- LSP 安装管理器
  { src = 'https://github.com/neovim/nvim-lspconfig' }, -- LSP 配置
  { src = 'https://github.com/nvim-mini/mini.pick' },   -- 文件/缓冲区选择器
  { src = 'https://github.com/nvim-mini/mini.files' },  -- 文件浏览器
})

-- Treesitter安装并懒加载
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' } -- 语法高亮和折叠
}, {
  load = function(plug_data)
    -- Treesitter 配置
    vim.api.nvim_create_autocmd("BufReadPre", {
      once = true,
      callback = function()
        vim.opt.runtimepath:append(plug_data.path)
        ---@diagnostic disable-next-line: missing-fields
        require('nvim-treesitter.configs').setup({
          ensure_installed = { 'lua', 'python', 'json', 'vim', 'markdown', 'c' }, -- 安装的语言
          highlight = { enable = true },                                          -- 语法高亮
          indent = { enable = true },                                             -- 缩进
        })
      end,
    })
  end
})

-- blink.cmp 安装补全配置以及触发加载
vim.pack.add({
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.*') },
}, {
  load = function(plug_data)
    -- 不执行任何操作，完全不加载插件
    -- 只在 InsertEnter 时手动添加到 runtimepath 并加载
    vim.api.nvim_create_autocmd("InsertEnter", {
      once = true,
      callback = function()
        -- 手动添加到 runtimepath
        vim.opt.runtimepath:append(plug_data.path)
        -- 加载 plugin 文件
        require('blink.cmp').setup({
          keymap = { preset = 'super-tab' },
          sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
          },
        })
      end,
    })
  end
})

----------------------
-- 颜色主题 --
----------------------
-- 延迟加载 gruvbox 主题
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.cmd("colorscheme gruvbox")
  end,
})

----------------------
-- 插件配置 --
----------------------
-- 插件延迟加载（在读取文件或创建新文件时加载）
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  callback = function()
    -- Mason
    require('mason').setup()
    -- mini.pick 配置
    require('mini.pick').setup()
    -- mini.files 文件浏览器配置
    require('mini.files').setup({
      windows = {
        preview = true, -- 打开预览窗口
      },
    })
  end,
})

-- Treesitter 配置(不起作用)
-- vim.api.nvim_create_autocmd("BufReadPre", {
--   once = true,
--   callback = function()
--     ---@diagnostic disable-next-line: missing-fields
--     require('nvim-treesitter.configs').setup({
--       ensure_installed = { 'lua', 'python', 'json', 'vim', 'markdown', 'c' }, -- 安装的语言
--       highlight = { enable = true },                                          -- 语法高亮
--       indent = { enable = true },                                             -- 缩进
--     })
--   end,
-- })

-- blink.cmp 补全配置以及触发加载(不起作用)
-- vim.api.nvim_create_autocmd({ "InsertEnter" }, {
--   once = true,
--   callback = function()
--     print("InsertEnter triggered at:", vim.loop.hrtime() / 1e6, "ms")
--     print("vim_did_enter:", vim.v.vim_did_enter)
--     require('blink.cmp').setup({
--       keymap = { preset = 'super-tab' },                   -- 超级 Tab 快捷键
--       sources = {
--         default = { 'lsp', 'path', 'snippets', 'buffer' }, -- 补全来源
--       },
--     })
--   end,
-- })

----------------------
-- LSP 配置 --
----------------------
-- 懒的做优化了
-- Lua LSP 配置 (lua_ls)
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') }, -- Lua 运行时
      diagnostics = { globals = { 'vim' } },                                 -- 忽略全局变量 vim 的警告
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      format = { enable = true }, -- 启用格式化
    },
  },
})

-- 启用 LSP
vim.lsp.enable({ 'lua_ls', 'pyright', 'clangd' })
-- LSP 诊断显示
vim.diagnostic.config({ virtual_text = true }) -- 行内文本提示
-- vim.diagnostic.config({ virtual_lines = true }) -- 虚拟行提示（可选）

----------------------
-- 快捷键配置 --
----------------------
-- 格式化
vim.keymap.set('n', '<leader>lf', function()
  vim.lsp.buf.format()
end, { desc = 'format' })

-- 系统剪贴板
vim.keymap.set({ 'n', 'v' }, '<leader>c', '"+y', { desc = 'copy to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>x', '"+d', { desc = 'cut to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'paste to system clipboard' })
-- 撤销
vim.keymap.set({ 'n', 'v', 'i' }, '<C-z>', '<ESC>u<CR>', { desc = 'undo' })
-- 窗口切换
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'focus windows' })
-- 行移动
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
-- 调整窗口大小
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })
-- 文件/插件快捷键
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<ESC>:write<CR>', { desc = 'save file' })
vim.keymap.set('n', '<leader>e', ':lua MiniFiles.open()<CR>', { desc = 'open file explorer' })
vim.keymap.set('n', '<leader>f', ':Pick files<CR>', { desc = 'open file picker' })
vim.keymap.set('n', '<leader>h', ':Pick help<CR>', { desc = 'open help picker' })
vim.keymap.set('n', '<leader>b', ':Pick buffers<CR>', { desc = 'open buffer picker' })
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'diagnostic messages' })
-- LSP 快捷键
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find references' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP code action' })
-- 快速跳转诊断
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump({ wrap = true, count = -1 })
end, { desc = 'prev diagnostic' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump({ wrap = true, count = 1 })
end, { desc = 'next diagnostic' })

----------------------
-- 自动命令 --
----------------------
-- 保存前自动格式化
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format()
  end,
  pattern = '*',
})

-- 复制高亮提示
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'highlight copying text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
})

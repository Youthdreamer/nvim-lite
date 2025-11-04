## 🧠 Neovim 0.12 配置示例：原生插件管理器版

轻量的 Neovim 0.12 配置示例，**无需额外插件管理器（如 lazy.nvim 或 packer.nvim）**，完全依赖 Neovim 新引入的官方 `vim.pack` API 来管理插件。
内置 LSP、自动补全、文件浏览与搜索、主题、格式化等功能。

---

### 📦 特性

* ✅ **原生插件管理**：使用 Neovim 0.12 内置的 `vim.pack.add()`
* 🎨 **经典主题**：`gruvbox`
* ⚙️ **LSP 支持**：`mason.nvim` + `nvim-lspconfig`
* 🪶 **轻量文件选择器 / 文件浏览器**：`mini.pick`、`mini.files`
* 🌳 **语法高亮与折叠**：`nvim-treesitter`
* 💬 **自动补全**：`blink.cmp`（懒加载）
* 🔧 **实用快捷键**：保存、格式化、LSP 跳转、窗口移动、系统剪贴板等

---

### 🚀 快速开始

#### 1️⃣ 环境要求

* Neovim **≥ 0.12**
* 推荐安装 `ripgrep`（文件搜索更快）

  ```bash
  # Windows
  winget install BurntSushi.ripgrep.MSVC

  # macOS
  brew install ripgrep

  # Linux (Debian/Ubuntu)
  sudo apt install ripgrep
  ```

#### 2️⃣ 克隆仓库

#### 3️⃣ 启动 Neovim

首次启动时，Neovim 会自动：

* 下载并安装所有插件；
* 初始化 Treesitter、LSP、文件浏览等功能；
* 自动设置 `gruvbox` 主题。

---

### 🧩 插件一览

| 插件                                                                                    | 功能        |
| ------------------------------------------------------------------------------------- | --------- |
| [morhetz/gruvbox](https://github.com/morhetz/gruvbox)                                 | 配色主题      |
| [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim)                       | LSP 安装管理器 |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                     | LSP 配置    |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法高亮与折叠   |
| [nvim-mini/mini.pick](https://github.com/nvim-mini/mini.pick)                         | 文件/缓冲区搜索  |
| [nvim-mini/mini.files](https://github.com/nvim-mini/mini.files)                       | 文件浏览器     |
| [saghen/blink.cmp](https://github.com/saghen/blink.cmp)                               | 自动补全框架    |

---

### 🖱️ 常用快捷键

| 功能        | 快捷键             |
| --------- | --------------- |
| 保存文件      | `<C-s>`         |
| 打开文件浏览器   | `<leader>e`     |
| 文件搜索      | `<leader>f`     |
| 查看缓冲区     | `<leader>b`     |
| 查看帮助      | `<leader>h`     |
| 格式化       | `<leader>lf`    |
| 跳转到定义     | `gd`            |
| LSP 重命名   | `<leader>rn`    |
| 打开诊断      | `<leader>dd`    |
| 上一个/下一个诊断 | `[d` / `]d`     |
| 移动行       | `Alt + j / k`   |
| 系统剪贴板复制粘贴 | `<leader>c/x/p` |

---

### 🧰 自动加载逻辑

* 插件通过 `vim.pack.add()` 注册
* Treesitter 在首次打开文件时加载
* `blink.cmp` 在第一次进入插入模式时加载
* 主题配置在 `VimEnter` 时加载

---

### 🧩 文件结构

```bash
~/.config/nvim/
└── init.lua     # 你的配置文件
```

---

### 🧠 说明与参考

* 本配置仅使用 Neovim 官方 API
* 适合希望深入理解 Neovim 新特性的用户

---

# 📖 站点维护指南

> 本文档帮助你快速上手维护本站点，包括目录结构、如何新增文档、可用功能及注意事项。

---

## 🗂️ 目录结构

```
/
├── index.html              # 站点入口（引用主题、样式与脚本）
├── css/
│   └── custom.css          # 全部自定义样式（主题色、封面、代码折叠等）
├── js/
│   ├── docsify.config.js   # Docsify 配置与自定义插件（Mermaid/MathJax/代码折叠）
│   ├── mathjax.config.js   # MathJax 配置
│   └── theme-toggle.js     # 暗色/亮色主题切换逻辑
├── docs/                   # 所有文档内容
│   ├── README.md           # 首页 / 文档首页
│   ├── _sidebar.md         # 侧边栏导航配置
│   ├── _navbar.md          # 顶部导航栏配置
│   ├── _coverpage.md       # 封面页
│   ├── _404.md             # 404 页面
│   ├── HELP.md             # 本文件
│   ├── daily/              # 个人日记
│   │   └── xxx.md
│   └── program/            # 编程笔记
│       ├── xxxxxx.md
│       ├── xxxxxx.md
│       ├── xxxxxx.md
│       └── xxxxxx.md
└── resource/               # 资源文件
    ├── files/
    └── images/
        ├── design/  letters/  posters/  tools/
```

---

## ✍️ 如何新增文档

1. 在 `docs/` 下创建 `.md` 文件（可放在子目录中）
2. 编辑 `docs/_sidebar.md`，添加导航链接
3. 如果需要在顶部导航栏显示，编辑 `docs/_navbar.md`
4. 本地预览满意后提交推送即可

**链接写法：**
```markdown
- [显示名称](相对路径.md)
- [我的笔记](program/my-script.md)
```

---

## 🚀 本地预览

```shell
# 在项目根目录运行
docsify serve .
# 访问 http://localhost:3000
```

> 使用 docsify-cli 5.x，已无旧版的 `punycode` 弃用警告。

---

## ⚡ 可用功能

| 功能 | 说明 | 使用方法 |
|------|------|----------|
| **主题切换** | 暗色/亮色一键切换 | 点击右下角 ☀️ / 🌙 按钮（偏好自动保存） |
| **代码折叠** | 长代码块可折叠，点击头部展开/收起 | 点击代码块头部任意位置（或按 `Enter`/`Space`） |
| **Mermaid 图表** | 流程图、时序图、甘特图、类图等 | 使用 ` ```mermaid ` 代码块 |
| **MathJax 公式** | LaTeX 数学公式渲染 | 行内 `$...$`，块级 `$$...$$` |
| **Emoji** | 快速插入表情 | 输入 `:smile:`、`:+1:`、`:rocket:` 等 |
| **全文搜索** | 搜索所有文档内容 | `Ctrl+K` / `Cmd+K` 或点击搜索图标 |
| **图片缩放** | 点击图片放大查看 | 鼠标左键单击任意图片 |
| **代码复制** | 一键复制代码片段 | 鼠标悬停代码块右上角按钮 |
| **分页导航** | 上下页快捷跳转 | 页面底部自动出现 |
| **更新时间** | 显示文件最后修改时间 | 页面末尾自动显示 |

---

## ⚠️ Mermaid 注意事项（v11）

> 本站使用 Mermaid 11（版本锁定 `mermaid@11`），语法要求比旧版更严格：

- ❌ **图内部不能有空行** — 空行会导致 `Syntax error`
- ❌ **不支持 `%%` 注释** — 请直接删除注释行
- ❌ **不支持 `~Cat~` 泛型语法** — 如 `List~String~` 需改为 `string[]`
- ✅ 使用 `branch` / `checkout`（**不是** `git branch` / `git checkout`）
- ✅ 标签语法 `tag:"v1.0"` 正常使用
- ✅ 前导元数据 `--- title: ... ---` 后需紧接图类型声明，不能有空行

---

## 🎨 主题说明

- **框架**：Docsify v5（核心主题 `core` + 暗色插件 `core-dark`）
- **暗色 / 亮色**：通过右下角 ☀️ / 🌙 按钮切换，偏好保存在浏览器 `localStorage`
- **主色调**：绛红（宫墙红 `#8C2633`），由 `css/custom.css` 中的 `--theme-color` 控制，**改这一处即可换色**
- **封面**：自适应明暗的绛红渐变背景，标题带渐变文字效果

---

## 📦 依赖清单

> 全部第三方资源均通过 `cdn.jsdmirror.com`（jsdelivr 中国镜像）加载，国内访问更快。

| 资源 | 版本 | 用途 |
|------|------|------|
| Docsify | 5.0.0 | 文档框架 |
| docsify-cli | 5.0.0 | 本地预览（`docsify serve`） |
| Mermaid | 11.x | 图表渲染 |
| MathJax | 3.x | 公式渲染 |
| docsify-copy-code | 3.x | 代码复制 |
| docsify-pagination | 2.x | 分页导航 |
| zoom-image | v5 内置 | 图片缩放 |

---

> 💡 **快速开始：** 在 `docs/` 下创建 `.md` 文件 → 更新 `_sidebar.md` → `docsify serve .` 预览 → 推送部署

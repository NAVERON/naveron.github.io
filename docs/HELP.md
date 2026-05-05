# 📖 站点维护指南

> 本文档帮助你快速上手维护本站点，包括目录结构、如何新增文档、可用功能及注意事项。

---

## 🗂️ 目录结构

```
/
├── index.html              # 站点入口，Docsify 配置、插件、主题
├── docs/                   # 所有文档内容
│   ├── README.md           # 首页 / 文档首页
│   ├── _sidebar.md         # 侧边栏导航配置
│   ├── _navbar.md          # 顶部导航栏配置
│   ├── _coverpage.md       # 封面页
│   ├── _404.md             # 404 页面
│   ├── HELP.md             # 本文件
│   ├── daily/              # 个人日记
│   │   └── summary.md
│   └── program/            # 编程笔记
│       ├── my-script.md
│       ├── git-learning.md
│       ├── code-style-guild.md
│       ├── mathjax-learning.md
│       ├── mermaid-learning.md
│       └── raspberry-pi-learning.md
└── resource/               # 资源文件
    └── images/
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

---

## ⚡ 可用功能

| 功能 | 说明 | 使用方法 |
|------|------|----------|
| **主题切换** | 暗色/亮色一键切换 | 点击右下角 ☀️ / 🌙 按钮（偏好自动保存） |
| **Mermaid 图表** | 流程图、时序图、甘特图、类图等 | 使用 ` ```mermaid ` 代码块 |
| **MathJax 公式** | LaTeX 数学公式渲染 | 行内 `$...$`，块级 `$$...$$` |
| **Emoji** | 快速插入表情 | 输入 `:smile:`、`:+1:`、`:rocket:` 等 |
| **全文搜索** | 搜索所有文档内容 | `Ctrl+K` / `Cmd+K` 或点击搜索图标 |
| **图片缩放** | 点击图片放大查看 | 鼠标左键单击任意图片 |
| **代码复制** | 一键复制代码片段 | 鼠标悬停代码块右上角按钮 |
| **分页导航** | 上下页快捷跳转 | 页面底部自动出现 |
| **更新时间** | 显示文件最后修改时间 | 页面末尾自动显示 |

---

## ⚠️ Mermaid 注意事项（v11.14.0）

> 本站使用 Mermaid 11.14.0，语法要求比旧版更严格：

- ❌ **图内部不能有空行** — 空行会导致 `Syntax error`
- ❌ **不支持 `%%` 注释** — 请直接删除注释行
- ❌ **不支持 `~Cat~` 泛型语法** — 如 `List~String~` 需改为 `string[]`
- ✅ 使用 `branch` / `checkout`（**不是** `git branch` / `git checkout`）
- ✅ 标签语法 `tag:"v1.0"` 正常使用
- ✅ 前导元数据 `--- title: ... ---` 后需紧接图类型声明，不能有空行

---

## 🎨 主题说明

- **暗色主题**（默认）：基于 [docsify-darkly-theme](https://github.com/sushantrahate/docsify-darkly-theme)
- **亮色主题**：基于 Docsify 官方 Vue 主题
- 切换偏好保存在浏览器 `localStorage` 中

---

## 📦 依赖清单

| 资源 | 版本 | 用途 |
|------|------|------|
| Docsify | 4.x | 文档框架 |
| Docsify Darkly Theme | latest | 暗色主题 |
| Mermaid | 11.14.0 | 图表渲染 |
| MathJax | 3.x | 公式渲染 |
| docsify-copy-code | latest | 代码复制 |
| docsify-pagination | latest | 分页导航 |

---

> 💡 **快速开始：** 在 `docs/` 下创建 `.md` 文件 → 更新 `_sidebar.md` → `docsify serve .` 预览 → 推送部署
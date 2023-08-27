---
title: Home
layout: home
nav_order: 1
---

# 玉龙视觉效果工作室 {: .fs-9}  

一个属于自己的天地 {: .fs-6 .fw-300}  

[VIEW ERON's GITHUB](https://github.com/NAVERON) {: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2}  

玉龙视觉效果工作室 (**玉龙视效工作室**)  
ERON VISUAL STUDIO (**EVS**)  

## 关于 

才疏学浅, 贻笑大方 {: .fw-500}  

### 关于我自己 

- [ ] 我的简介[NAVERON](https://github.com/NAVERON/NAVERON)  
- [ ] 随笔资料心得[ERON](https://github.com/NAVERON/ERON)  
- [ ] 开发环境重建脚本[CONFIG](https://github.com/NAVERON/CONFIG)  
- [ ] ......

### 主要项目 

- [ShipSimulation](https://github.com/NAVERON/ShipSimulation)  
- [ArbitraryCoding](https://github.com/NAVERON/ArbitraryCoding)  
- [SpecializedExercises](https://github.com/NAVERON/SpecializedExercises)  
- ......

## 开始 

十步杀一人, 千里不留行. 事了拂衣去, 深藏身与名 {: .fw-500}  

### 文档头

一般一个父级路径下包含多个子文档， 形成多级菜单

**位于docs路径下， 创建子文件夹， 然后设置一个顶级目录， 其余作为顶级目录的子文档**  

父级目录文档头
```markdown
---
title: Utilities  # 显示当前目录名称
layout: default  # 布局， post, about, home, default ...
nav_order: 4  # 在目录中的显示位置
has_children: true  # 表示是否有子文档/目录 
permalink: docs/about  # 请求路径
---
```

中间级目录文档头
```markdown
---
title: A minimal layout page  # 名称
layout: minimal  # 布局
parent: Layout  # 父级名称， 即 父级 title的名字
has_children: true  # 是否有子目录 
---
```

子目录文档头
```
---
title: Minimal layout child page  # 文章显示名
layout: minimal  # 布局设置
parent: A minimal layout page  # 父级目录 title
grand_parent: Layout  # 上上级路径 
---
```

### 绘图工具  

**Github支持的绘图** : [Write On Github](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/about-writing-and-formatting-on-github)  

**mermaid绘图工具的使用**  : [Mermaid Start](https://mermaid.js.org/intro/)  



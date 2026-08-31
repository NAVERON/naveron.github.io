
# MathJax 学习笔记：语法速查与练习

> 这份文档是我早期学习 MathJax / LaTeX 语法时的记录整理，后面不断补充和归纳。我把它重新整理成更系统的速查形式，方便以后直接查用。

MathJax 是一个用于在网页中优雅展示数学公式的 JavaScript 引擎。它可以渲染 TeX、MathML 和 ASCIIMath 等输入形式，适合用于 Markdown、Docsify、博客、教学页面和文档站点。

官方主页：<https://www.mathjax.org/>

---

## 1. 基础概念：行内公式与行间公式

MathJax 中最常用的做法是把公式写在 TeX 语法中，并由浏览器渲染为数学表达式。

### 1.1 行内公式

通常使用 `$...$`：

```latex
$E = mc^2$
```

显示：

$$E = mc^2$$

### 1.2 行间公式

通常使用 `$$...$$`：

```latex
$$\sum_{i=0}^n i^2 = \frac{(n^2+n)(2n+1)}{6}$$
```

显示：

$$\sum_{i=0}^n i^2 = \frac{(n^2+n)(2n+1)}{6}$$

> 备注：在一些静态站点或 Markdown 解析器中，`$...$` 的行为可能不稳定，因此我在笔记里更多使用 `$$...$$` 作为展示公式的统一写法。

---

## 2. 结构元素：变量、上下标、分组

### 2.1 Greek 字母

```latex
$$\alpha, \beta, \gamma, \omega$$
```

显示：

$$\alpha, \beta, \gamma, \omega$$

大写字母也可以这样写：

```latex
$$\Gamma, \Delta, \Omega$$
```

显示：

$$\Gamma, \Delta, \Omega$$

### 2.2 上标和下标

```latex
$$x_i^2, \quad \log_2 x$$
```

显示：

$$x_i^2, \quad \log_2 x$$

> 上标使用 `^`，下标使用 `_`。如果内容超过一项，最好使用大括号分组，例如 `x^{10}` 和 `a_{ij}`。

### 2.3 分组

```latex
$$10^{10}, \quad {x^y}^z$$
```

显示：

$$10^{10}, \quad {x^y}^z$$

---

## 3. 分数、根号和常用函数

### 3.1 分数

```latex
$$\frac{a}{b}, \quad \frac{a+1}{b+1}$$
```

显示：

$$\frac{a}{b}, \quad \frac{a+1}{b+1}$$

也可以写成更直观的形式：

```latex
$${a+1} \over {b+1}$$
```

显示：

$${a+1} \over {b+1}$$

### 3.2 根号

```latex
$$\sqrt{x^3}, \quad \sqrt[3]{\frac{x}{y}}$$
```

显示：

$$\sqrt{x^3}, \quad \sqrt[3]{\frac{x}{y}}$$

### 3.3 极限与常见函数

```latex
$$\lim_{x \to 0} \frac{\sin x}{x} = 1$$
```

显示：

$$\lim_{x \to 0} \frac{\sin x}{x} = 1$$

```latex
$$\sum_{i=0}^{\infty} \frac{1}{2^i} = 2$$
```

显示：

$$\sum_{i=0}^{\infty} \frac{1}{2^i} = 2$$

---

## 4. 括号与分隔符

### 4.1 普通括号

```latex
$$(a+b), [x+y], \{u,v\}$$
```

显示：

$$(a+b), [x+y], \{u,v\}$$

### 4.2 自动缩放括号

如果希望括号随公式大小自适应，可以使用 `\left` 和 `\right`：

```latex
$$\left(\frac{\sqrt{x}}{y^3}\right)$$
```

显示：

$$\left(\frac{\sqrt{x}}{y^3}\right)$$

常见的分隔符：

```latex
$$\langle a, b \rangle, \quad \lceil x \rceil, \quad \lfloor x \rfloor$$
```

显示：

$$\langle a, b \rangle, \quad \lceil x \rceil, \quad \lfloor x \rfloor$$

也可以使用 `\middle` 来控制中间分隔符：

```latex
$$\left\langle q \middle\| \frac{\frac{x}{y}}{\frac{u}{v}} \middle\| \right\rangle$$
```

显示：

$$\left\langle q \middle\| \frac{\frac{x}{y}}{\frac{u}{v}} \middle\| \right\rangle$$

---

## 5. 矩阵与数组

### 5.1 基础矩阵

```latex
$$
\begin{matrix}
1 & x & x^2 \\
1 & y & y^2 \\
1 & z & z^2
\end{matrix}
$$
```

显示：

$$
\begin{matrix}
1 & x & x^2 \\
1 & y & y^2 \\
1 & z & z^2
\end{matrix}
$$

### 5.2 带括号的矩阵

```latex
$$
\begin{pmatrix}
1 & 2 \\
3 & 4
\end{pmatrix}
$$
```

显示：

$$
\begin{pmatrix}
1 & 2 \\
3 & 4
\end{pmatrix}
$$

### 5.3 array 形式

```latex
$$
\begin{array}{l|lcr}
n & \text{left} & \text{center} & \text{right} \\
1 & 0.24 & 1 & 125 \\
2 & -1 & 189 & -8 \\
3 & -20 & 2000 & 1+10i
\end{array}
$$
```

显示：

$$
\begin{array}{l|lcr}
n & \text{left} & \text{center} & \text{right} \\
1 & 0.24 & 1 & 125 \\
2 & -1 & 189 & -8 \\
3 & -20 & 2000 & 1+10i
\end{array}
$$

> `&` 用来分隔单元，`\\` 用来换行，`c/l/r` 表示列对齐方式。

---

## 6. 公式对齐：align 与 cases

### 6.1 align

```latex
$$
\begin{align}
\sqrt{37} & = \sqrt{\frac{73^2-1}{12^2}} \\
& = \sqrt{\frac{73^2}{12^2} \cdot \frac{73^2-1}{73^2}} \\
& = \frac{73}{12} \cdot \sqrt{1-\frac{1}{73^2}}
\end{align}
$$
```

显示：

$$
\begin{align}
\sqrt{37} & = \sqrt{\frac{73^2-1}{12^2}} \\
& = \sqrt{\frac{73^2}{12^2} \cdot \frac{73^2-1}{73^2}} \\
& = \frac{73}{12} \cdot \sqrt{1-\frac{1}{73^2}}
\end{align}
$$

### 6.2 分段函数：cases

```latex
$$
f(n) =
\begin{cases}
\frac{n}{2}, & \text{if $n$ is even} \\
3n+1, & \text{if $n$ is odd}
\end{cases}
$$
```

显示：

$$
f(n) =
\begin{cases}
\frac{n}{2}, & \text{if $n$ is even} \\
3n+1, & \text{if $n$ is odd}
\end{cases}
$$

### 6.3 aligned

```latex
$$
\left\{
\begin{aligned}
a_1x+b_1y+c_1z &= d_1+e_1 \\
a_2x+b_2y &= d_2 \\
a_3x+b_3y+c_3z &= d_3
\end{aligned}
\right.
$$
```

显示：

$$
\left\{
\begin{aligned}
a_1x+b_1y+c_1z &= d_1+e_1 \\
a_2x+b_2y &= d_2 \\
a_3x+b_3y+c_3z &= d_3
\end{aligned}
\right.
$$

---

## 7. 空格、文字和样式

### 7.1 空格

```latex
$$a\ b, \quad a\qquad b$$
```

显示：

$$a\ b, \quad a\qquad b$$

### 7.2 公式中插入文本

```latex
$$\text{if } n \text{ is even}$$
```

显示：

$$\text{if } n \text{ is even}$$

### 7.3 样式切换

```latex
$$\displaystyle\sum_{n=1}^{\infty}\frac{1}{n^2}$$
```

显示：

$$\displaystyle\sum_{n=1}^{\infty}\frac{1}{n^2}$$

也可以用 `\textstyle`：

```latex
$$\textstyle\sum_{n=1}^{\infty}\frac{1}{n^2}$$
```

显示：

$$\textstyle\sum_{n=1}^{\infty}\frac{1}{n^2}$$

---

## 8. 文字修饰、符号与常用装饰

```latex
$$\hat{x}, \bar{x}, \vec{v}, \overline{AB}, \underline{xy}$$
```

显示：

$$\hat{x}, \bar{x}, \vec{v}, \overline{AB}, \underline{xy}$$

```latex
$$\boxed{e^x = \sum_{n=0}^{\infty}\frac{x^n}{n!}}$$
```

显示：

$$\boxed{e^x = \sum_{n=0}^{\infty}\frac{x^n}{n!}}$$

---

## 9. 标签、引用和等式标注

在 Docsify / Markdown 的这个环境里，最稳妥的写法是直接用 `$$ ... $$` 这种展示公式语法，而不要直接把 `\begin{equation}` 这类原始 TeX 环境写在普通段落里。因为 Markdown 会把反斜杠原样输出，导致看起来像纯文本。

```latex
$$
a = x^2 - y^3 \label{eq:demo}
$$
```

显示：

$$
a = x^2 - y^3 \label{eq:demo}
$$

引用时可用：

```latex
$$
a + y^3 \stackrel{\eqref{eq:demo}}{=} x^2
$$
```

显示：

$$
a + y^3 \stackrel{\eqref{eq:demo}}{=} x^2
$$

如果需要手动设置编号，也可以这样写：

```latex
$$
a = x^2 - y^3 \tag{1} \label{eq:manual}
$$
```

> 在这个站点中，`$$ ... $$` 是最稳定的公式渲染写法；如果代码里直接出现 `\begin{equation}`，很容易被当成普通文本输出。

---

## 10. 绝对值、箭头和常见符号

```latex
$$|x|, \quad ||v||, \quad \lvert x \rvert, \lVert v \rVert$$
```

显示：

$$|x|, \quad ||v||, \quad \lvert x \rvert, \lVert v \rVert$$

```latex
$$\Rightarrow, \quad \Leftarrow, \quad \Leftrightarrow$$
```

显示：

$$\Rightarrow, \quad \Leftarrow, \quad \Leftrightarrow$$

---

## 11. 语法练习：常见公式写法训练

下面这几块内容可以直接作为练习，帮助我以后快速复用。

### 练习 1：求和公式

```latex
$$\sum_{k=1}^{n} k = \frac{n(n+1)}{2}$$
```

显示：

$$\sum_{k=1}^{n} k = \frac{n(n+1)}{2}$$

### 练习 2：极限公式

```latex
$$\lim_{x \to 0} \frac{\sin x}{x} = 1$$
```

显示：

$$\lim_{x \to 0} \frac{\sin x}{x} = 1$$

### 练习 3：分段函数

```latex
$$
f(x)=
\begin{cases}
-x, & x<0 \\
x^2, & x\ge 0
\end{cases}
$$
```

显示：

$$
f(x)=
\begin{cases}
-x, & x<0 \\
x^2, & x\ge 0
\end{cases}
$$

### 练习 4：矩阵

```latex
$$
\begin{pmatrix}
1 & 2 & 3 \\
0 & 1 & 4 \\
0 & 0 & 1
\end{pmatrix}
$$
```

显示：

$$
\begin{pmatrix}
1 & 2 & 3 \\
0 & 1 & 4 \\
0 & 0 & 1
\end{pmatrix}
$$

### 练习 5：多行对齐

```latex
$$
\begin{align}
(a+b)^2 &= a^2 + 2ab + b^2 \\
(a-b)^2 &= a^2 - 2ab + b^2
\end{align}
$$
```

显示：

$$
\begin{align}
(a+b)^2 &= a^2 + 2ab + b^2 \\
(a-b)^2 &= a^2 - 2ab + b^2
\end{align}
$$

---

## 12. 一些实用建议

- 公式尽量写清晰，复杂表达式用大括号分组。
- `\frac{}`、`\sqrt{}`、`\sum_{}^{}` 是最常用的基础命令。
- 行间公式适合展示定理、推导和长公式；行内公式适合说明变量关系。
- 如果要控制括号大小，优先使用 `\left` 和 `\right`。
- 当公式比较长时，优先用 `align` / `cases` / `array` 等环境来保证结构更清晰。

---

## 13. 总结

MathJax 的核心并不复杂，真正关键的是熟悉几类常见结构：

- 基本符号：字母、上下标、分式、根号
- 结构化环境：matrix、array、cases、align
- 括号与定界符：`\left`、`\right`、`\middle`
- 公式展示控制：`\text`、`\displaystyle`、`\textstyle`
- 引用与标签：`\label`、`\tag`、`\eqref`

这些内容是我学习 MathJax 时反复实践并整理出来的，后续如果需要写更复杂的数学公式，基本都可以从这里快速翻阅。

---

## 14. 扩展资源

- MathJax 官方站：<https://www.mathjax.org/>
- MathJax 文档：<https://docs.mathjax.org/>
- LaTeX 公式速查：常见符号、分式、矩阵、积分等
- 公式编辑器：可用于辅助检查 TeX 语法是否正确

这个笔记的目标不是完整的 LaTeX 教程，而是把我学习过程中最常用、最关键的公式语法整理成一份速查手册。以后遇到公式时，可以直接往这里找写法。

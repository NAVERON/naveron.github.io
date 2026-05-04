# 我的脚本

> 记录日常编写的脚本、工具和编程心得。

## Python 脚本示例

```python
def fibonacci(n):
    """生成斐波那契数列"""
    a, b = 0, 1
    for _ in range(n):
        yield a
        a, b = b, a + b

# 输出前 10 个斐波那契数
print(list(fibonacci(10)))
```

## Mermaid 流程图

```mermaid
flowchart LR
  A[需求分析] --> B[设计]
  B --> C[编码]
  C --> D[测试]
  D --> E[部署]
  E --> F[维护]
```

## MathJax 公式

时间复杂度：$O(n \log n)$

$$
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}
$$

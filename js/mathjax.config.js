/* =========================================================
   MathJax 配置
   ⚠ 必须在 mathjax 脚本加载之前引入
   ========================================================= */
window.MathJax = {
    tex: {
        inlineMath: [['$', '$'], ['\\(', '\\)']],
        displayMath: [['$$', '$$'], ['\\[', '\\]']]
    },
    options: {
        skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre']
    },
    startup: { typeset: false }
};

/* =========================================================
   ERON Docsify 插件：Mermaid + MathJax
   ========================================================= */
{
    function eronMermaidMathJax(hook) {
        hook.beforeEach(function (content) {
            return content.replace(/```mermaid([\s\S]*?)```/g, function (_, code) {
                return '<div class="mermaid">' + code.trim() + '</div>';
            });
        });

        hook.doneEach(function () {
            renderMermaid();
            typesetMathJax();
        });
    }

    function renderMermaid() {
        if (!window.mermaid) return;

        if (!window.__eronMermaidReady) {
            window.__eronMermaidReady = true;
            window.mermaid.initialize({ startOnLoad: false });
        }

        var nodes = document.querySelectorAll('.mermaid');
        if (!nodes.length) return;

        window.mermaid.run({ nodes: nodes }).catch(function (error) {
            console.error('Mermaid 渲染失败:', error);
        });
    }

    function typesetMathJax() {
        if (window.MathJax && window.MathJax.typesetPromise) {
            window.MathJax.typesetPromise().catch(function (error) {
                console.error('MathJax 排版失败:', error);
            });
        }
    }

    window.$docsify = window.$docsify || {};
    window.$docsify.plugins = [eronMermaidMathJax, ...(window.$docsify.plugins || [])];
}

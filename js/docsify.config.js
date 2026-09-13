/* =========================================================
   Docsify 配置与自定义插件
   ⚠ 必须在 docsify.min.js 之前引入
   ========================================================= */
window.$docsify = {
    name: 'ERON VISUAL STUDIO',
    coverpage: true,
    basePath: 'docs/',
    homepage: 'README.md',
    loadSidebar: true,
    loadNavbar: true,
    auto2top: true,
    maxLevel: 3,
    subMaxLevel: 2,
    notFoundPage: '_404.md',
    formatUpdated: '{YYYY}/{MM}/{DD}',
    // v5：自定义浏览器标签页标题中的站点名（默认使用配置的 name）
    pageTitleFormatter: function () {
        return '玉龙视觉效果工作室';
    },
    search: {
        paths: 'auto',
        placeholder: '输入搜索内容',
        noData: '未找到匹配项',
        depth: 2
    },
    plugins: [
        // ---- Mermaid + MathJax 渲染 ----
        function (hook) {
            hook.beforeEach(function (content) {
                return content.replace(/```mermaid([\s\S]*?)```/g, function (_, code) {
                    return '<div class="mermaid">' + code.trim() + '</div>';
                });
            });
            hook.doneEach(function () {
                renderMermaid();
                typesetMathJax();
            });
        },
        // ---- 代码块折叠 / 展开 ----
        function (hook) {
            hook.doneEach(function () {
                bindCodeCollapse();
            });
        }
    ]
};

/* ================= 工具函数 ================= */

// 渲染 Mermaid 图表（mermaid v11 使用 mermaid.run）
function renderMermaid() {
    if (!window.mermaid) return;
    if (!window.__mermaidReady) {
        window.__mermaidReady = true;
        mermaid.initialize({ startOnLoad: false });
    }
    var nodes = document.querySelectorAll('.mermaid');
    if (!nodes.length) return;
    mermaid.run({ nodes: nodes }).catch(function (err) {
        console.error('Mermaid 渲染失败:', err);
    });
}

// 触发 MathJax 重新排版
function typesetMathJax() {
    if (window.MathJax && MathJax.typesetPromise) {
        MathJax.typesetPromise().catch(function (err) {
            console.error(err);
        });
    }
}

// 为每个代码块绑定折叠 / 展开（点击整个代码块头部即可折叠/展开）
function bindCodeCollapse() {
    var pres = document.querySelectorAll('.markdown-section pre');
    Array.prototype.forEach.call(pres, function (pre) {
        if (pre.__collapseBound) return;
        pre.__collapseBound = true;

        var wrapper = document.createElement('div');
        wrapper.className = 'code-block-wrapper';

        // 可点击的代码块头部
        var toolbar = document.createElement('div');
        toolbar.className = 'code-block-toolbar';
        toolbar.setAttribute('role', 'button');
        toolbar.tabIndex = 0;
        toolbar.title = '折叠代码';
        toolbar.setAttribute('aria-label', '折叠代码');

        // 折叠提示（折叠时显示）
        var hint = document.createElement('span');
        hint.className = 'code-collapse-hint';
        hint.textContent = '已折叠 · 点击展开';

        // 折叠指示图标（展开 ▾ / 折叠 ▸）
        var icon = document.createElement('span');
        icon.className = 'code-collapse-icon';
        icon.setAttribute('aria-hidden', 'true');
        icon.textContent = '▾';

        toolbar.appendChild(hint);
        toolbar.appendChild(icon);

        function applyState() {
            var collapsed = pre.classList.contains('collapsed');
            wrapper.classList.toggle('collapsed', collapsed);
            icon.textContent = collapsed ? '▸' : '▾';
            var label = collapsed ? '展开代码' : '折叠代码';
            toolbar.title = label;
            toolbar.setAttribute('aria-label', label);
        }

        toolbar.addEventListener('click', function () {
            pre.classList.toggle('collapsed');
            applyState();
        });
        toolbar.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                pre.classList.toggle('collapsed');
                applyState();
            }
        });

        pre.parentNode.insertBefore(wrapper, pre);
        wrapper.appendChild(toolbar);
        wrapper.appendChild(pre);
    });
}

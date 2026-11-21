/* =========================================================
   ERON Docsify 插件：代码块折叠
   ========================================================= */
{
    function eronCodeCollapse(hook) {
        hook.doneEach(function () {
            bindCodeCollapse();
        });
    }

    function bindCodeCollapse() {
        var pres = document.querySelectorAll('.markdown-section pre');

        Array.prototype.forEach.call(pres, function (pre) {
            if (pre.__collapseBound) return;
            pre.__collapseBound = true;

            var wrapper = document.createElement('div');
            wrapper.className = 'code-block-wrapper';

            var toolbar = document.createElement('div');
            toolbar.className = 'code-block-toolbar';
            toolbar.setAttribute('role', 'button');
            toolbar.tabIndex = 0;
            toolbar.title = '折叠代码';
            toolbar.setAttribute('aria-label', '折叠代码');

            var hint = document.createElement('span');
            hint.className = 'code-collapse-hint';
            hint.textContent = '已折叠 · 点击展开';

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

            toolbar.addEventListener('keydown', function (event) {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    pre.classList.toggle('collapsed');
                    applyState();
                }
            });

            pre.parentNode.insertBefore(wrapper, pre);
            wrapper.appendChild(toolbar);
            wrapper.appendChild(pre);
        });
    }

    window.$docsify = window.$docsify || {};
    window.$docsify.plugins = [eronCodeCollapse, ...(window.$docsify.plugins || [])];
}

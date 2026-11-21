/* =========================================================
   ERON Docsify 插件：明暗主题切换
   ========================================================= */
{
    function eronThemeToggle(hook) {
        hook.mounted(function () {
            var themeDarkCss = document.getElementById('theme-css-dark');
            var themeButton = document.getElementById('theme-toggle');

            if (!themeButton) {
                themeButton = document.createElement('button');
                themeButton.id = 'theme-toggle';
                themeButton.title = '切换主题';
                document.body.appendChild(themeButton);
            }

            function applyTheme(dark) {
                if (themeDarkCss) themeDarkCss.disabled = !dark;
                document.documentElement.classList.toggle('light-theme', !dark);
                themeButton.textContent = dark ? '☀️' : '🌙';
                localStorage.setItem('theme', dark ? 'dark' : 'light');
            }

            themeButton.setAttribute('aria-label', '切换明暗主题');
            themeButton.addEventListener('click', function () {
                applyTheme(document.documentElement.classList.contains('light-theme'));
            });

            applyTheme(localStorage.getItem('theme') !== 'light');
        });
    }

    window.$docsify = window.$docsify || {};
    window.$docsify.plugins = [eronThemeToggle, ...(window.$docsify.plugins || [])];
}

/* =========================================================
   主题切换：暗色（默认）/ 亮色
   通过启用 / 停用 docsify v5 的 core-dark 暗色插件实现
   ========================================================= */
(function () {
    var themeDarkCss = document.getElementById('theme-css-dark');
    var themeBtn = document.getElementById('theme-toggle');
    var themeIsDark = localStorage.getItem('theme') !== 'light';

    function applyTheme(dark) {
        themeIsDark = dark;
        if (themeDarkCss) themeDarkCss.disabled = !dark;
        document.documentElement.classList.toggle('light-theme', !dark);
        if (themeBtn) themeBtn.textContent = dark ? '☀️' : '🌙';
        localStorage.setItem('theme', dark ? 'dark' : 'light');
    }

    if (themeBtn) {
        themeBtn.addEventListener('click', function () {
            applyTheme(!themeIsDark);
        });
    }

    applyTheme(themeIsDark);
})();

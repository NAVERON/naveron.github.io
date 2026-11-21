/* =========================================================
   Docsify 配置
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
    }
};

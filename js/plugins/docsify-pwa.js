/* =========================================================
   ERON Docsify 插件：PWA 离线缓存注册
   ========================================================= */
{
    function eronPwa(hook) {
        hook.ready(function () {
            if (!('serviceWorker' in navigator)) return;

            navigator.serviceWorker.register('./sw.js', { scope: './' }).catch(function (error) {
                console.error('Service Worker 注册失败:', error);
            });
        });
    }

    window.$docsify = window.$docsify || {};
    window.$docsify.plugins = [eronPwa, ...(window.$docsify.plugins || [])];
}

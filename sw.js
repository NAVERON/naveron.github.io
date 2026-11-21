/* ===========================================================
 * ERON Docsify PWA Service Worker
 * ===========================================================
 * 为静态站点提供离线缓存与低速网络容错。
 * 缓存策略：访问即缓存（stale-while-revalidate）。
 * ========================================================== */

const RUNTIME = 'eron-docsify-v2';

// 仅拦截本站及项目实际使用的外部资源主机。
// self.location.hostname 会自动包含 Codeberg Pages 或本地开发域名。
const HOSTNAME_WHITELIST = [
    self.location.hostname,
    'jsdelivr.topthink.com',
    'cdn.jsdelivr.net',
    'readme-typing-svg.demolab.com',
    'komarev.com',
    'img.shields.io',
];

const PRECACHE_URLS = [
    './',
    './index.html',
    './css/custom.css',
    './js/docsify.config.js',
    './js/mathjax.config.js',
    './js/plugins/docsify-theme-toggle.js',
    './js/plugins/docsify-mermaid-mathjax.js',
    './js/plugins/docsify-code-collapse.js',
    './js/plugins/docsify-pwa.js',
    './docs/README.md',
    './docs/_sidebar.md',
    './docs/_navbar.md',
    './docs/_coverpage.md',
    './docs/_404.md',
];

// 给同源 GET 请求附加缓存破坏参数，绕过静态托管的缓存过期限制。
function getFixedUrl(request) {
    const url = new URL(request.url);

    if (url.protocol === 'http:') {
        url.protocol = self.location.protocol;
    }

    if (url.hostname === self.location.hostname) {
        url.searchParams.set('cache-bust', Date.now().toString());
    }

    return url.href;
}

self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(RUNTIME)
            .then(cache => cache.addAll(PRECACHE_URLS))
            .then(() => self.skipWaiting()),
    );
});

self.addEventListener('activate', event => {
    event.waitUntil(
        caches.keys()
            .then(keys => Promise.all(
                keys
                    .filter(key => key !== RUNTIME)
                    .map(key => caches.delete(key)),
            ))
            .then(() => self.clients.claim()),
    );
});

self.addEventListener('fetch', event => {
    const request = event.request;

    if (request.method !== 'GET') return;

    let requestUrl;
    try {
        requestUrl = new URL(request.url);
    } catch (_) {
        return;
    }

    if (HOSTNAME_WHITELIST.indexOf(requestUrl.hostname) === -1) return;

    const cached = caches.match(request);
    const fixedUrl = getFixedUrl(request);
    const fetched = fetch(fixedUrl, {
        cache: 'no-store',
    });
    const fetchedCopy = fetched.then(response => response.clone());

    event.respondWith(
        Promise.race([fetched.catch(() => cached), cached])
            .then(response => response || fetched)
            .catch(async () => {
                if (request.mode === 'navigate') {
                    const index = await caches.match('./index.html');
                    if (index) return index;
                }
                return new Response('', {
                    status: 503,
                    statusText: 'Offline',
                });
            }),
    );

    event.waitUntil(
        Promise.all([fetchedCopy, caches.open(RUNTIME)])
            .then(([response, cache]) => {
                if (response && (response.ok || response.type === 'opaque')) {
                    return cache.put(request, response);
                }
            })
            .catch(() => { /* 离线或资源不可用时忽略缓存更新 */ }),
    );
});

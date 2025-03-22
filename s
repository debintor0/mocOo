const CACHE_NAME = 'moco-cache-v2';
const urlsToCache = [
  '/', 
  '/index.html',
  '/styles.css', 
  '/script.js',  
  '/logo.png'
];

// Install Service Worker & Cache Semua File
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('Caching semua file');
      return cache.addAll(urlsToCache);
    })
  );
});

// Fetch Data dari Cache atau Internet
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      return response || fetch(event.request).then((networkResponse) => {
        return caches.open(CACHE_NAME).then((cache) => {
          cache.put(event.request, networkResponse.clone());
          return networkResponse;
        });
      });
    }).catch(() => {
      return caches.match('/index.html'); // Jika offline, tampilkan halaman utama
    })
  );
});

// Hapus Cache Lama saat SW Baru Aktif
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('Menghapus cache lama:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});

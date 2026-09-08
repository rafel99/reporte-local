// Service worker mínimo: cachea el "shell" de la app (HTML, iconos, manifest)
// para que abra al instante y funcione, en modo lectura, incluso sin conexión.
// Los datos de reportes viven en Supabase, no aquí — esto solo cachea la interfaz.

const CACHE_NAME = "al-tanto-shell-v1";
const SHELL_FILES = [
  "./",
  "./index.html",
  "./manifest.json",
  "./icons/icon-192.png",
  "./icons/icon-512.png"
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(SHELL_FILES))
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

// Estrategia: red primero (para tener datos frescos), y si no hay conexión,
// se sirve la copia cacheada del shell. Las llamadas a Supabase (otro dominio)
// se dejan pasar directo a la red, sin cachear.
self.addEventListener("fetch", (event) => {
  const url = new URL(event.request.url);
  if (url.origin !== self.location.origin) return; // no tocar llamadas a Supabase

  event.respondWith(
    fetch(event.request)
      .then((res) => {
        const copy = res.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy));
        return res;
      })
      .catch(() => caches.match(event.request))
  );
});

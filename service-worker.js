const VERSION = "grocify-v3";
const STATIC_CACHE = `${VERSION}-static`;
const RUNTIME_CACHE = `${VERSION}-runtime`;
const APP_SHELL = [
  "./",
  "./index.html",
  "./grocify-gsheetv3.0-Codex.html",
  "./manifest.json",
  "./offline.html",
  "./icon.svg",
  "./icon-maskable.svg",
  "./apple-touch-icon.png",
  "./icon-192.png",
  "./icon-512.png"
];

const NETWORK_FIRST_PATTERNS = [
  /\/$/,
  /index\.html$/,
  /grocify-gsheetv3\.0-Codex\.html$/,
  /manifest\.json$/,
  /icon(-maskable)?\.svg$/,
  /icon-(192|512)\.png$/
];

function shouldUseNetworkFirst(url, request) {
  return request.mode === "navigate" || NETWORK_FIRST_PATTERNS.some((pattern) => pattern.test(url.pathname));
}

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(STATIC_CACHE).then((cache) => cache.addAll(APP_SHELL))
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys
          .filter((key) => ![STATIC_CACHE, RUNTIME_CACHE].includes(key))
          .map((key) => caches.delete(key))
      )
    )
  );
  self.clients.claim();
});

async function networkFirst(request, fallbackKey) {
  try {
    const response = await fetch(request, { cache: "no-store" });
    const cache = await caches.open(RUNTIME_CACHE);
    cache.put(fallbackKey || request, response.clone());
    return response;
  } catch {
    const cached = await caches.match(fallbackKey || request);
    if (cached) return cached;
    if (request.mode === "navigate") {
      return caches.match("./offline.html");
    }
    // FIX: return 503 instead of throwing an unhandled error
    return new Response("Offline", { status: 503, statusText: "Service Unavailable" });
  }
}

async function staleWhileRevalidate(request) {
  const cached = await caches.match(request);
  const fetchPromise = fetch(request)
    .then(async (response) => {
      const cache = await caches.open(RUNTIME_CACHE);
      cache.put(request, response.clone());
      return response;
    })
    .catch(() => cached);

  return cached || fetchPromise;
}

self.addEventListener("fetch", (event) => {
  const { request } = event;

  if (request.method !== "GET") {
    return;
  }

  const url = new URL(request.url);

  if (url.origin !== self.location.origin) {
    return;
  }

  if (shouldUseNetworkFirst(url, request)) {
    event.respondWith(networkFirst(request));
    return;
  }

  event.respondWith(staleWhileRevalidate(request));
});

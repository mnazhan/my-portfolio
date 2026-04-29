'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "3d0d8982a0e0fc12d3dc715f44008c92",
"version.json": "9b818ca9511483c901bed1545384376c",
"index.html": "190f64c96ce174ac26ac5c543bf82a87",
"/": "190f64c96ce174ac26ac5c543bf82a87",
"main.dart.js": "95ed5aa87ddb9a2866a0947714b18c68",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "082b5dcb3d9d0fe645a1be68bc5a30dd",
"icons/Icon-192.png": "2e68ecfd1e5335f3d19ace6bb9237293",
"icons/Icon-maskable-192.png": "2e68ecfd1e5335f3d19ace6bb9237293",
"icons/Icon-maskable-512.png": "c00cdb897681818a9e6df886749901f9",
"icons/Icon-512.png": "c00cdb897681818a9e6df886749901f9",
"manifest.json": "e2b9103aaafaf8ed9f90576c9d9a1341",
"assets/AssetManifest.json": "03db5d70c795e06b607a61e6016a9fe9",
"assets/NOTICES": "670667825f42567914ab1b9781dca621",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "06fc442fc739091cd1011c5b2595f39f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "dc861d1f22ff69bd385a86471a3b819f",
"assets/fonts/MaterialIcons-Regular.otf": "c0bfb7a6a249f731f932e7026af80083",
"assets/assets/images/riverpod_logo.svg": "94a47782db272193d3ea572816132a0e",
"assets/assets/images/scrum.png": "c38f9a340c465e79d92d59ef130f3e18",
"assets/assets/images/javascript.svg": "9e8f3c6daefcb8ec50921eb35ece04dd",
"assets/assets/images/sql_lite.svg": "0d0e086cb2a609b3ee9f852043b0b02d",
"assets/assets/images/supabase.svg": "cb1d29f8a985973fff60cfbbe635e51c",
"assets/assets/images/java.svg": "3f2fe008e3ef4f712c7dd0e126e8333d",
"assets/assets/images/nazhan.jpg": "7b39fdf7f609dabb584c3ef8d854a134",
"assets/assets/images/nazhan_profile.svg": "8776c56c712afad1f994d1b64ca86b5b",
"assets/assets/images/nazhan_profile.png": "22c88648168537c900f61c2264f61753",
"assets/assets/images/c-programming.svg": "235c0ecb02c9405dc5aa0e465ef5d600",
"assets/assets/images/python.svg": "5d2e32f41ba50999281a02c7e368c8af",
"assets/assets/images/linux.png": "e1e82f42a889005f38806051f50b58c9",
"assets/assets/images/test_logo.svg": "67254dfe7e0c273a8c3ecc05de80f24c",
"assets/assets/images/flutter_logo.svg": "d7d24d86c8bbe5ee829301c149657bf4",
"assets/assets/images/c-sharp.svg": "37341874fbc37c4335f6e4087cde3f40",
"assets/assets/images/agile_logo.svg": "5ed84cd519adeb452b736fe5ca13484f",
"assets/assets/images/angularjs.svg": "64a3fd7590b5db223724cf2a893ed381",
"assets/assets/images/sqlite.svg": "f754bd9d3592ee14064391dcc4f77c39",
"assets/assets/images/git_logo.svg": "fb4afe3c43bd34215d0e7c3ab48e0455",
"assets/assets/images/css.svg": "13bceeeab2b0e0f8fade33a2b456e3ce",
"assets/assets/images/mysql_logo.svg": "498cb0ea10a07bc0d83ee7bc04120759",
"assets/assets/images/windows.svg": "cb8cdfeb87bbaa33811fa78d7f1eca8a",
"assets/assets/images/supa_base.svg": "44f9589c479039a08d33c0c638d90810",
"assets/assets/images/c++.svg": "383b24cb352034bc1fea60ae53bbe3c9",
"assets/assets/images/arduino.svg": "510f3b0bf2b036ec77a3410b85842f29",
"assets/assets/images/bloc_logo.svg": "a1454caa77db7a677d469ac3177dbaed",
"assets/assets/images/firebase_logo.svg": "bc05ebdd614297445ab6eab78046d3fc",
"assets/assets/images/provider_logo.svg": "3157cd4186d668d334463fa99b266cf0",
"assets/assets/images/php.png": "ca29e241ea2f0316617de81d7dfc0623",
"assets/assets/images/html.svg": "a930d315c1b859de60cc42ae9674f6b4",
"assets/assets/images/sqlite.png": "ee4847a4d7a2ccdd636a529922dd99d2",
"assets/assets/images/dart_logo.svg": "650fd52a3d9796e91d0664ee23c5a863",
"assets/assets/projects/vestai/sing_in_screen.jpeg": "4fd937c1f2e430a08462b3a668b886dd",
"assets/assets/projects/vestai/log_in_screen.jpeg": "c31238a983c4305d6ebf402950ddb652",
"assets/assets/projects/vestai/receiver_screen.jpeg": "c4b6202f1472c9f3b567c83e4fce3969",
"assets/assets/projects/vestai/dashboard_screen.jpeg": "928323f4b02d25cbedc230b196fac596",
"assets/assets/projects/vestai/user_screen.jpeg": "1ede17edce5bcdcf34b4f658f10df954",
"assets/assets/projects/vestai/supplier_screen.jpeg": "7e4332259825c6c7402f8926887329dc",
"assets/assets/projects/vestai/vetai_app_screen_recording.mp4": "02df04ebe541795c2a153a38ef3002c5",
"assets/assets/projects/vestai/report_screen.jpeg": "b6f8ee9cd699722b7b1330425e3d5b04",
"assets/assets/projects/card_game/card_game_screen_record.mp4": "501e418367096879190cc93e2f0ec5c9",
"assets/assets/projects/card_game/card_game_3.jpeg": "ea9d2ce85203302778f9e1889aea1a8c",
"assets/assets/projects/card_game/card_game_2.jpeg": "102082f03fe4124600ae048ab709cce8",
"assets/assets/projects/card_game/card_game_1.jpeg": "1fd798885d55b7dc9bd369cea18bca2b",
"assets/assets/projects/GSIS/gsis_web_complete_details_video.mp4": "ebde6f77c200a6eeab2fbbc76417dfb3",
"assets/assets/projects/GSIS/gsis_screen_2.png": "2b25c45195fd2a65361e2bb74c0ec56a",
"assets/assets/projects/GSIS/gsis_screen_3.png": "29cf5a1c8fba50174234577e54163a44",
"assets/assets/projects/GSIS/gsis_screen_4.png": "5ca0fc57bfe8f68b10019820663c1e3b",
"assets/assets/projects/GSIS/gsis_screen1.png": "eb2f9f70763e4bcf4e4abf89bf6f8e41",
"assets/assets/projects/GSIS/gsis_mobile_screen_record.mp4": "40696ba905c7d60f1bf0f5e2bdcff141",
"assets/assets/projects/GSIS/gsis_mobile_screen_record_2.mp4": "92e39306be9c932f6321b4052b0cfe8f",
"assets/assets/projects/GYM/gym_2.jpeg": "c3bfcdd5021ed538e120287b137ebefc",
"assets/assets/projects/GYM/gym_3.jpeg": "cb059d5af8818e41ce1c44fc67c05836",
"assets/assets/projects/GYM/gym_4.jpeg": "250b6140a0b907b01ff60d4037c4ebf5",
"assets/assets/projects/GYM/gym_5.jpeg": "18261ae9a0109163f7c2ca86a715a4c0",
"assets/assets/projects/GYM/gym_screen_record.mp4": "3ba76bda9eaee7940a513d3fd9b77057",
"assets/assets/projects/GYM/gym_1.jpeg": "fae527325e6d3725d1cc0e745e2fff00",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

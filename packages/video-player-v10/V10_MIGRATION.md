# Video.js v10 migration — status & plan

Working sandbox at **`packages/video-player-v10/`** on branch **`feature/videojs-v10`**.
Pinned to **`@videojs/core@10.0.0-beta.23`** (latest published as of 2026-04-27).

Last reviewed: 2026-05-06.

## v10 status

- v10 ships under new scoped packages: `@videojs/core`, `@videojs/html`, `@videojs/element`, `@videojs/icons`, `@videojs/spf`, `@videojs/cli`. The legacy `video.js` package on npm has no v10 release.
- Roadmap: GA mid-2026. API still flagged as moveable until GA. Recent betas (18, 20, 23) carry `**breaking**` entries.
- Per the v10 roadmap: *"No plugin migrations yet, without plugin author contribution"* at beta. Plugin ecosystem migration begins "in earnest" at GA.

## Why this is a rewrite, not an upgrade

v10 is a full architectural rebuild, not an incremental release.

- UI is composed of HTML custom elements (`<media-play-button>`, `<media-time-slider>`, `<media-popover>`, ...) instead of `videojs.getComponent(...)` subclasses.
- State is centralized in a player store backed by TC39 Signals. Components attach to the store via context.
- Skins are eject-and-customize presets (HTML or React). Class names and DOM shape do not match v8 (`.video-js`, `.vjs-control-bar`, `vjs-brunstadtv-skin`).
- The `videojs.registerPlugin(...)` API does not exist. "Plugins" become custom elements, components, or store features.
- HLS is handled by Hls.js, native HLS, or `@videojs/spf` (their MSE engine). Mux is a first-class media element. Chromecast is built into core via the Remote Playback API.

## What's been implemented

The sandbox at `packages/video-player-v10/` boots, plays HLS, and surfaces the public API. Concrete deliverables:

- **`createPlayer(containerId, opts)` wrapper** — thin facade over the v10 element tree. Public API surface preserved (see below).
- **Ejected default skin** — `src/video-player/skin/skin.ts` (DOM builder) + `skin.css` (verbatim ejected styles, ~700 lines). Light-DOM composition so we can insert custom controls into the bottom button group without subclassing or shadow-DOM hacks.
- **Live mode (`live: true`)** — drops seek buttons, time displays, slider, thumbnail preview, seek hotkeys/gestures. Adds a clickable LIVE badge that seeks to live edge.
- **Custom in-bar controls (`src/video-player/components/`):**
  - `bccm-audio-picker` — engine-based audio language picker (subscribes to `engine.audioTracks`).
  - `bccm-subtitle-picker` — store-based, uses `selectTextTrack` + DOM `textTracks` for selection.
  - `bccm-quality-picker` — engine-based, lists Auto + each rendition by height.
  - `bccm-playback-rate-picker` — store-based via `selectPlaybackRate`. Hardcodes a sane rate list (`[0.5, 0.75, 1, 1.25, 1.5, 1.75, 2]`); v10 core's default `[0.2, 0.5, 0.7, 1, 1.2, 1.5, 1.7, 2]` is intentionally overridden.
  - `bccm-live-button` — clickable LIVE badge; seeks to `engine.liveSyncPosition` (or `seekable.end` fallback). Indicates at-live vs behind-live via `[data-at-live]`.
- **Native HTML popover API** for picker menus — top-layer rendering so `backdrop-filter` actually sees the video underneath.

## Migration matrix

| # | Piece | Status | Notes |
|---|---|---|---|
| 1 | `videojs(el, opts)` core wiring | **Done** | Replaced with `createPlayer(...)` + a `<video-player>` / `<media-container>` tree. v8 options accepted but ignored when not applicable; new `live` option added. |
| 2 | v8 default skin + custom BTV skin | **Done (default ejected)** | Default v10 skin ejected; BTV brand styling not yet reapplied. |
| 3 | `videojs-mux` analytics | **Not needed** | The v8 import was a side-effect only — never configured (`player.mux(...)` is not called anywhere in source or git history). Plugin was loaded but never initialized. Safe to drop entirely. |
| 4 | `@silvermine/videojs-chromecast` | **Done** | `<media-cast-button>` (Remote Playback API) in the right group. Auto-hides via `[data-availability="unsupported"]` on browsers without RP. |
| 5 | `videojs-contrib-quality-levels` | **Done** | Replaced by `bccm-quality-picker` reaching into `engine.levels`. `Player.setVideoQuality(height)` wired to `engine.currentLevel`. |
| 6 | `videojs-event-tracking` | **Dropped** | Audited — zero consumers across `bcc-media-platform`. Sole maintainer confirms BCC uses NPAW exclusively for video analytics. The plugin's events (`tracking:firstplay`, `tracking:pause`, `tracking:seek`, `tracking:buffered`, `tracking:performance`, `tracking:*-quarter`) are derivable from standard media events on `Player.mediaEl` if anyone ever needs them. |
| 7 | `npaw-plugin-nwf` + `npaw-plugin-adapters` | **Done (pending dashboard verification)** | NPAW already ships `HlsjsAdapter` for hls.js. v10's `<hls-video>` exposes `.engine` (the hls.js instance), so we register the prebuilt adapter against it directly — no custom adapter needed. `enableNPAW()` waits for `media.engine` to materialize, then calls `npaw.registerAdapterFromClass(engine, HlsjsAdapter)`. Track changes (which `HlsjsAdapter` doesn't report natively but `VideoJsAdapter` did) are wired manually via `adapter.fireEvent("subtitleChange", ...)` / `fireEvent("audioChange", ...)` on `media.textTracks` "change" events and hls.js `hlsAudioTrackSwitched` events. Costs +800 KB bundle (NPAW SDK weight, same as v8). Verify events arrive in the NPAW dashboard before declaring fully done. |
| 8 | Forked `videojs-hls-quality-selector` | **Done** | Deleted. Replaced by `bccm-quality-picker`. |
| 9 | `seek-buttons.ts` (15s seek) | **Done** | `<media-seek-button seconds="-15"/+15">` in the ejected skin. |
| 10 | `smart-tv.ts` (`DismissControlBarButton`) | **Done** | New `bccm-dismiss-controls-button` extends `MediaElement`, subscribes to `selectControls`, calls `toggleControls()` on click when controls are visible. Only rendered when `isSmartTV()` returns true. Replaced `ua-parser-js` with a regex-based UA test in the same change — net bundle savings (~30 KB). |
| 11 | `smooth-seek.ts` | **Redundant** | Confirmed — v10's `<media-time-slider>` covers it via optimistic seek (alpha.10, #799) and pointer capture (alpha.5, #762). No port needed. The v8 monkey-patch can be deleted from `bccm-video-player@1.x` as a cleanup. |
| 12 | `videojs-smallscreen.ts` | **Probably unneeded** | v10 is responsive by default; gestures cover touch tap-to-toggle. May still need verification on mobile breakpoints. |
| 13 | Hotkeys | **Done** | `<media-hotkey>` elements in skin (Space/k/m/f/c/i/Arrow keys). Seek hotkeys omitted in live mode. |
| 14 | Live UI (`liveui`, `liveTracker.trackingThreshold`) | **Done (engine path)** | Live skin variant + `bccm-live-button`. Currently uses `engine.liveSyncPosition`; could switch to `selectLive` + `liveVideoFeatures` for store-based detection. |
| 15 | VHS fine-tuning options | **Done** | `overrideNative` is v10's default (`preferPlayback="mse"`). `limitRenditionByPlayerDimensions` mapped to `capLevelToPlayerSize: true` on `<hls-video>`. `useBandwidthFromLocalStorage` replicated via `setupBandwidthPersistence()` — reads on init to seed `abrEwmaDefaultEstimate`, writes throttled to 10s on `hlsFragLoaded`. The rest dropped: `cacheEncryptionKeys` is hls.js default, `experimentalBufferBasedABR` doesn't apply (hls.js has its own ABR), `allowSeeksWithinUnsafeLiveWindow` / `useDevicePixelRatio` / `nativeAudio,VideoTracks` have no equivalent (accepted losses). |
| 16 | Audio/subtitle language helpers | **Done** | `setAudioTrackToLanguage` / `setSubtitleTrackToLanguage` ported. New `getAudioLanguages()` / `getSubtitleLanguages()` enumerators added. |
| 17 | 401/403 segment-loader → "session expired" | **Done** | v10's `HlsJsMediaErrorsMixin` dispatches `ErrorEvent` on `<hls-video>` for fatal hls.js errors with `event.error.data.response.code`. `setupErrorHandling()` in `index.ts` listens, populates `<media-alert-dialog-title>` and `<media-alert-dialog-description>` — "Session expired" + reload instruction for 401/403, generic for everything else. v10's error dialog auto-opens on the underlying error state. |
| 18 | `btv-player` wrapper layer | **Done** | Updated to drop `videojs.mergeOptions` (replaced with object spread). Public API unchanged. |
| 19 | `vjs-brunstadtv-skin` class hook | **Open** | Currently uses v10's `media-default-skin` classes. BTV brand customization not yet applied. |
| 20 | Demo (`demo/App.vue`) | **Done** | Mounts both VOD + live players; `live: true` option used. |

## Public API surface (preserved)

All v8-era entry points work in the v10 sandbox. The `Player` interface gained a few additions but is backwards-compatible.

| Method / property | v8 | v10 sandbox |
|---|---|---|
| `createPlayer(containerId, opts): Promise<Player>` | ✓ | ✓ |
| `setNPAWOptions(player, opts)` | ✓ | ✓ (no-op stub) |
| `Player.setAudioTrackToLanguage(language)` | ✓ | ✓ (hls.js engine + native fallback) |
| `Player.setSubtitleTrackToLanguage(language)` | ✓ | ✓ (DOM textTracks) |
| `Player.setVideoQuality(height)` | ✓ | ✓ (hls.js `engine.currentLevel`) |
| `onProgress(currentTime, duration, player)` | ✓ | ✓ (`timeupdate` listener) |
| `Options.npaw / subtitles / videojs / languagePreferenceDefaults / src / autoplay` | ✓ | ✓ |
| `Options.live: boolean` | — | new |
| `Player.dispose()` | — | new |
| `Player.element` / `Player.mediaEl` | — | new (escape hatch) |
| `Player.getAudioLanguages() / getSubtitleLanguages()` | — | new |

## Open work

In rough priority order:

1. **Verify NPAW dashboard receives events** — implementation done (uses NPAW's prebuilt `HlsjsAdapter` against the hls.js engine). Needs an end-to-end check against a real NPAW account.
2. **Optional: switch to `liveVideoFeatures` + custom `<bccm-live-video-player>`** — would let `bccm-live-button` use `selectLive` / `liveEdgeStart` from the store instead of poking the engine. Cleaner but adds a custom factory.

### Cleanup wins (independent of v10)

- **Drop `videojs-mux` from `bccm-video-player@1.x`** — the side-effect import is dead code. Pure bundle-size win, no behavior change.
- **Drop `videojs-event-tracking` from `bccm-video-player@1.x`** — zero consumers across BCC apps; NPAW is the only analytics path used.
- **Delete `smooth-seek.ts` from `bccm-video-player@1.x`** — the monkey-patch is redundant with modern video.js seekbar behavior; v10 confirms this concept is no longer needed.

## Decisions made along the way

- **Engine reach-around vs. v10 store** — for features the default `videoFeatures` bundle doesn't expose (audio tracks, quality levels, live edge), we read directly from `media.engine` (hls.js). The store path would require building a custom player factory with a custom feature bundle. We'll switch when those features land in core or when the engine path becomes painful.
- **Native popover API over CSS show/hide** — picker menus use `popover="auto"` so they render in the top layer. This is the only way `backdrop-filter` produces the frosted-glass look — inside `.media-controls`'s own surface, the filter has nothing to blur.
- **Hardcoded playback rates** — v10 core's defaults include 0.2/0.7/1.2/1.7. We override with `[0.5, 0.75, 1, 1.25, 1.5, 1.75, 2]` in the picker.
- **Custom skin via light-DOM composition** — the docs recommend ejecting the skin for "rearrange / remove controls". Full template lives in `src/video-player/skin/skin.ts`, so we own it. Keeps custom controls (pickers, live button) inline with the v10 button-group structure.
- **Unique tooltip / popover IDs per skin** — multiple players on one page (the demo has two) would collide on `commandfor` references otherwise. Each `buildSkin` call gets a `${seq}` suffix on every ID it emits.

## Recommended sequence to ship

1. **Verify NPAW dashboard** — confirm playback / pause / seek / buffer / error / quality events arrive correctly with a test account.
2. **Switch consumers behind a `2.0.0`** package version. Don't replace `bccm-video-player@1.x` in place — let consumers opt in.
3. **Hold cutover until v10 ships GA** (or at minimum a beta with no `**breaking**` notes for several weeks). API is still flagged moveable.

BTV brand styling deferred — the default v10 skin is acceptable for now.

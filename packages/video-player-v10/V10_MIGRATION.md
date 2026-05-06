# Video.js v10 migration audit

Status snapshot for `packages/video-player` against Video.js v10. Last reviewed 2026-05-06.

## v10 status

- v10 ships under new scoped packages: `@videojs/core`, `@videojs/html`, `@videojs/react`, `@videojs/element`, `@videojs/skins`, `@videojs/icons`, `@videojs/spf`, `@videojs/cli`. The legacy `video.js` package on npm has no v10 release.
- Latest published: `@videojs/core@10.0.0-beta.23` (2026-04-27).
- Roadmap: GA mid-2026. API still flagged as moveable until GA. Recent betas (18, 20, 23) carry `**breaking**` entries.
- Per the v10 roadmap: *"No plugin migrations yet, without plugin author contribution"* at beta. Plugin ecosystem migration "begins in earnest" at GA.

## Why this is a rewrite, not an upgrade

v10 is a full architectural rebuild, not an incremental release.

- UI is composed of HTML custom elements (`<media-play-button>`, `<media-time-slider>`, `<media-popover>`, ...) instead of `videojs.getComponent(...)` subclasses.
- State is centralized in a player store backed by TC39 Signals. Components attach to the store via context.
- Skins are eject-and-customize presets (HTML or React). Class names and DOM shape do not match v8 (`.video-js`, `.vjs-control-bar`, `vjs-brunstadtv-skin`).
- The `videojs.registerPlugin(...)` API does not exist. "Plugins" become custom elements, components, or store features.
- HLS is handled by Hls.js, native HLS, or `@videojs/spf` (their MSE engine). Mux is a first-class media element. Chromecast is built into core via the Remote Playback API.

The implication: nothing in `src/video-player/index.ts:184-276` (the `setupVideoJs` wiring) carries over verbatim. The classes in `src/video-player/plugins/*.ts` need to be rewritten as custom elements / store consumers. The skin in `src/video-player/skin/` needs to be redesigned against v10's eject output.

## Migration matrix

| # | Current piece | Location | LoC | Status | Notes |
|---|---|---|---|---|---|
| 1 | `videojs` core import + `setupVideoJs` | `src/video-player/index.ts` | ~277 | **Rewrite** | Replace `videojs(el, opts)` with `createPlayer(...)` from `@videojs/html`. The v8 options surface (`html5.vhs`, `liveui`, `inactivityTimeout`, `techOrder`, `userActions.hotkeys`) does not map 1:1 — most of it is per-feature config now. |
| 2 | v8 default skin (`video-js.css`) + custom skin | `video-js/dist/video-js.css`, `src/video-player/skin/style.scss` (283 lines) + `_small-screen-ui.scss` (67) + `_plugins.scss` (32) | ~382 | **Rewrite** | Eject a v10 skin preset (HTML or React). Reapply the BTV brand styling against the new class names. Background-gradient hack at `style.scss:215-232` becomes a CSS custom property in v10's theme system. |
| 3 | `videojs-mux` analytics | `package.json`, `index.ts:5` | side-effect import | **Drop-in via core** | v10 ships a built-in Mux video element (beta.12, #1036). Mux Data init is in core (`Fix Mux data initialization`, beta.12). Confirm v10 mux-video matches our `videojs-mux@4.21.28` config surface — needs a small spike. |
| 4 | `@silvermine/videojs-chromecast` | `package.json`, `index.ts:10,28-31`, `_plugins.scss:2` | ~third-party | **Drop-in via core** | v10 has chromecast via Remote Playback API (beta.22, #1348). Replace `CastLoader.load()` + `registerChromecastPlugin(videojs)` with the v10 cast feature. Local SVG icons (`chromecast.svg`, `chromecast-filled.svg`) and SCSS overrides in `_plugins.scss:5-32` likely become CSS custom properties. |
| 5 | `videojs-contrib-quality-levels` | `package.json`, `index.ts:3` | side-effect | **Likely drop-in via core** | v10 core handles HLS rendition tracking and (per `liveEdgeStart`/`targetLiveWindow`, beta.23) live-window primitives. Need to confirm the public API for enumerating quality levels and that it covers our `setVideoQuality(height)` use case. |
| 6 | `videojs-event-tracking` | `package.json`, `index.ts:4` | side-effect | **Verify** | This package is a thin event taxonomy. v10's media element fires standard media events. May be replaceable with direct event listeners on the new media element. Need to inventory which events are actually consumed downstream of this player. |
| 7 | `npaw-plugin-nwf` + `npaw-plugin-adapters` | `package.json`, `src/video-player/npaw.ts` (73 lines), `index.ts:6,58-60` | ~73 | **BLOCKER** | Vendor-controlled. Current adapter is `NpawAdapters.video.Videojs` — explicitly v8. No v10 adapter exists. **Action: contact NPAW for v10 plans before committing to a migration date.** Workaround: hand-roll an adapter against v10 store events (non-trivial). |
| 8 | Forked `videojs-hls-quality-selector` | `external-projects/videojs-hls-quality-selector/src/plugin.js` (257 lines) + `plugin.scss` (9), wired in `index.ts:9,21-24,211,258-273` | ~266 | **Rewrite (small)** | Throw away the fork. v10 ships slider-based UI primitives (`<media-time-slider>`, `<media-volume-slider>`, etc.). Build a `<media-quality-popover>` against the v10 quality-levels API. The `setVideoQuality(height)` public method on the player must be preserved. |
| 9 | `seek-buttons.ts` (15s seek fwd/back) | `src/video-player/plugins/seek-buttons.ts` | 29 | **Drop-in via core** | v10 has a built-in `SeekButton` component (alpha.1, #526) and seek hotkeys (beta.16). Replace both classes with `<media-seek-button seconds="-15">` / `<media-seek-button seconds="15">`. |
| 10 | `smart-tv.ts` (`DismissControlBarButton`) | `src/video-player/plugins/smart-tv.ts` | 19 | **Rewrite (trivial)** | A single button that calls `userActive(false)`. Reimplement as a small custom element that toggles `controls` feature. v10 has `toggleControls` (beta.16, #1280). |
| 11 | `smooth-seek.ts` (monkey-patches `SeekBar.prototype`) | `src/video-player/plugins/smooth-seek.ts` | 38 | **Investigate** | Patches `getPercent` and `handleMouseMove` on v8's SeekBar to allow scrubbing past the buffered range. v10's `<media-time-slider>` already has "optimistic current time on seek" (alpha.10, #799) and pointer capture (alpha.5, #762) — verify if the smooth-scrub behavior we need is already default. If so, **delete**. |
| 12 | `videojs-smallscreen.ts` (touch + width-based UI swap) | `src/video-player/plugins/videojs-smallscreen.ts` | 40 | **Rewrite (trivial)** | Pure DOM/class toggling on `playerresize` + touch detection. Reimplement as a custom element observer or replace with CSS container queries against v10's player root. |
| 13 | Hotkeys (`userActions.hotkeys: true`) | `index.ts:129-131` | 1 line | **Drop-in via core** | v10 ships a hotkey system with coordinator, ARIA, action bindings (beta.16, #1238/#1239). Wire it via `<media-hotkey>` or core `hotkeys` config. |
| 14 | Live UI (`liveui: true`, `liveTracker.trackingThreshold`) | `index.ts:122-125` | a few lines | **Drop-in via core** | v10 has `liveEdgeStart` and `targetLiveWindow` primitives (beta.23, #1445) and live-video presets (beta.23, #1399). Reapply the 15s threshold via the new config surface. |
| 15 | VHS fine-tuning (`experimentalBufferBasedABR`, `useBandwidthFromLocalStorage`, `overrideNative`, `cacheEncryptionKeys`, ...) | `index.ts:108-120` | ~13 lines of options | **Rewrite (config)** | These options are VHS-specific. v10 routes HLS through Hls.js, native HLS, or `@videojs/spf`. Each switch needs a v10 equivalent (or a decision to drop). The `cacheEncryptionKeys` and bandwidth-from-localStorage flags in particular need verification — they may not have direct equivalents. |
| 16 | Audio-track / subtitle-track language helpers | `index.ts:150-182` | ~33 | **Rewrite** | Use v10's text-track store (alpha.5, #643) and subtitles handling (alpha.9, #692). The `tracks_` field-poking and `// @ts-ignore Types are outdated` comments go away. |
| 17 | 401/403 segment-loader error → "session expired" | `index.ts:213-228` | ~16 | **Rewrite** | Reaches into `player.tech().vhs.masterPlaylistController_.mainSegmentLoader_` — internal VHS state that does not exist in v10. Replace with v10's error feature (alpha.8, #713) and HLS error handling (beta.14, beta.12 #1164). |
| 18 | `btv-player` wrapper layer | `src/btv-player/index.ts` | 69 | **Likely drop-in** | This is the consumer-facing wrapper. As long as the public API (`createPlayer`, `setNPAWOptions`, `setVideoQuality`, `setAudioTrackToLanguage`, `setSubtitleTrackToLanguage`, `onProgress`) is preserved by the new internal implementation, this layer barely changes. |
| 19 | `vjs-brunstadtv-skin` class hook + `vjs-show-startup-spinner` | `index.ts:140-148` | a few lines | **Rewrite** | The class names are tied to v8's DOM. New skin will use v10's data attributes (e.g. `data-availability`, `data-state`). |
| 20 | Demo (`demo/App.vue`, `demo/main.ts`, `index.html`) | `demo/` | small | **Rewrite (trivial)** | Update to import the new player. Keep Vue if useful — v10 doesn't ship Vue bindings, but a Vue host is fine since v10's HTML elements are framework-agnostic custom elements. |

## Public API surface that must be preserved

These are the entry points the rest of the codebase consumes; the v10 implementation must keep them working.

- `createPlayer(containerId, opts: Partial<Options>): Promise<Player>` (`src/video-player/index.ts:36`)
- `setNPAWOptions(player, opts)` (`index.ts:136`)
- `Player.setAudioTrackToLanguage(language)` (`index.ts:252`)
- `Player.setSubtitleTrackToLanguage(language)` (`index.ts:255`)
- `Player.setVideoQuality(height)` (`index.ts:258`)
- `onProgress(currentTime, duration, player)` callback (`index.ts:242-248`)
- The `Options` interface (`index.ts:65-79`) — including the `npaw`, `subtitles`, `videojs`, `languagePreferenceDefaults`, `src` shape

## Open questions / blockers

1. **NPAW v10 support.** Single biggest unknown. Without a v10-compatible NPAW adapter, analytics breaks on cutover. Reach out to NPAW or evaluate whether direct adapter code against v10 store events is acceptable.
2. **Mux integration parity.** Does v10's built-in `<media-mux-video>` cover everything `videojs-mux@4.21.28` does for our metadata? Spike needed.
3. **VHS option parity.** Several `html5.vhs.*` flags (`cacheEncryptionKeys`, `useBandwidthFromLocalStorage`, `experimentalBufferBasedABR`, `useDevicePixelRatio`) need explicit mapping or accepted-loss decisions.
4. **`videojs-event-tracking` consumers.** Need to find who downstream listens to which tracked events before deciding whether v10's standard media events suffice.
5. **Smart TV / smallscreen UX.** v10's gesture and hotkey systems should cover smart-TV navigation, but needs a hands-on test on actual TV browsers.
6. **HLS engine choice.** Hls.js vs native vs `@videojs/spf` is a live decision. Current player uses `overrideNative: true` (forces VHS). v10's equivalent default behavior needs to be confirmed.
7. **Bundle size.** Current bundle is 1.99 MB unminified. v10's modular elements + tree-shaking should help — but Hls.js, Mux, chromecast, NPAW, and skin assets all add up. Worth measuring on a prototype.

## Recommended sequence

1. **Wait for GA or near-GA beta.** API is still moving (breaking changes in beta.18/20/23). Starting now means rework on every beta drop.
2. **Resolve NPAW (#7) before committing to a date.** This is the only true external blocker — the rest is in our control.
3. **Spike a parallel `packages/video-player-v10/`** with `@videojs/core` beta + Mux + HLS. Goal: prove the public API surface (above) can be reimplemented. Budget: ~1 week.
4. **Replicate the migration matrix** as Linear/issue tickets so the work is parallelizable across the team.
5. **Cut over consumers behind a build-flag or new package version.** Don't replace `bccm-video-player` in place; ship a `@2.0.0` that consumers opt into.

# bccm-video-player

HLS video player built on Video.js v10. Custom skin with audio / subtitle / quality / playback-rate pickers, live mode, NPAW analytics, and Chromecast.

## Install

```sh
pnpm add bccm-video-player
```

```ts
import { createPlayer } from "bccm-video-player"
import "bccm-video-player/css"
```

## Quick start

```html
<div id="player"></div>
```

```ts
const player = await createPlayer("player", {
    src: { src: "https://example.com/stream.m3u8" },
    autoplay: false,
    languagePreferenceDefaults: { audio: "eng", subtitles: "eng" },
})
```

## Options

```ts
createPlayer(containerId, options)
```

| Option                                 | Type                                      | Notes                                                                                                                                                                                                                                         |
| -------------------------------------- | ----------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `src.src`                              | `string`                                  | HLS / DASH manifest URL.                                                                                                                                                                                                                      |
| `autoplay`                             | `boolean`                                 |                                                                                                                                                                                                                                               |
| `live`                                 | `boolean`                                 | Switches to the live skin: LIVE badge, no seek buttons / time displays / thumbnails.                                                                                                                                                          |
| `language`                             | `string`                                  | UI language for tooltips, pickers, and error messages. Built-in: `"en"`, `"no"`, `"nl"` (default `"en"`). Unsupported codes fall back to `"en"`. Swap at runtime with `player.setLanguage(...)`. See [Adding a language](#adding-a-language). |
| `languagePreferenceDefaults.audio`     | `string`                                  | 3-letter code, e.g. `"eng"`.                                                                                                                                                                                                                  |
| `languagePreferenceDefaults.subtitles` | `string`                                  | 3-letter code, or omit to disable.                                                                                                                                                                                                            |
| `subtitles`                            | `Track[]`                                 | External `<track>` descriptors (`src`, `srclang`, `label`, `kind`).                                                                                                                                                                           |
| `videojs.poster`                       | `string`                                  | Poster image URL.                                                                                                                                                                                                                             |
| `videojs.crossOrigin`                  | `string`                                  | Defaults to `"anonymous"`.                                                                                                                                                                                                                    |
| `npaw`                                 | `NPAWOptions`                             | See [Analytics](#analytics).                                                                                                                                                                                                                  |
| `onProgress`                           | `(currentTime, duration, player) => void` | Fires on `timeupdate`.                                                                                                                                                                                                                        |

## Player API

```ts
interface Player {
    element: HTMLElement // <video-player> root
    mediaEl: HTMLVideoElement // underlying <hls-video> (use for play/pause/volume/events)
    getAudioLanguages(): TrackOption[]
    getSubtitleLanguages(): TrackOption[]
    setAudioTrackToLanguage(language?: string): void
    setSubtitleTrackToLanguage(language?: string): void
    setVideoQuality(height: number): void // 0 / negative re-enables Auto (ABR)
    setLanguage(lang: string): void // swaps UI strings live; unsupported codes fall back to "en"
    dispose(): void
}
```

For low-level control (play / pause / volume / events), use `player.mediaEl`:

```ts
player.mediaEl.play()
player.mediaEl.volume = 0.5
player.mediaEl.addEventListener("play", () => {
    /* ... */
})
```

## Theming

The skin reads CSS variables from the player container.

| Variable               | Default                | Effect                                                                                                                                 |
| ---------------------- | ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `--bccm-color-primary` | `oklch(1 0 0)` (white) | Text / icon color across the whole skin. Cascades via `currentColor` to slider fill, focus ring, hover backgrounds, live-badge accent. |
| `--bccm-color-accent`  | `oklch(1 0 0)` (white) | Background of primary-action buttons (e.g. the OK on the error dialog). Foreground text auto-flips black/white based on lightness.     |

Set on the container:

```html
<div id="player" style="--bccm-color-accent: #6EB0E6"></div>
```

## Adding a language

Drop a file into `src/video-player/i18n/locales/`. The filename is the language code.

```ts
// src/video-player/i18n/locales/de.ts
import type { LocaleTable } from "../strings"

const de: LocaleTable = {
    seekBackward: "{seconds} Sekunden zurück",
    seekForward: "{seconds} Sekunden vor",
    // ... TypeScript will fail until every key in LocaleTable is filled in.
}

export default de
```

The build picks it up automatically via `import.meta.glob` — no registration step. `en.ts` is the canonical reference for which keys exist and how interpolation placeholders (e.g. `{seconds}`, `{height}`, `{label}`) are spelled. Anything not translated falls back to English at runtime.

## Keyboard

In picker menus (audio / subtitles / quality / playback rate):

- `↑ / ↓` — roam wrapping
- `Home / End` — first / last item
- `Enter / Space` — select
- `Tab / Shift+Tab` — leave the popover, continue along the control bar
- `Esc` — close, restore focus to trigger

## Analytics (NPAW)

```ts
createPlayer("player", {
    src: { src: "..." },
    npaw: {
        enabled: true,
        accountCode: "...",
        appName: "web",
        tracking: {
            isLive: false,
            userId: "...",
            sessionId: "...",
            metadata: {
                contentId: "E385",
                title: "...",
                showTitle: "...",
            },
        },
    },
})
```

Adds ~800 KB to the bundle. Omit `npaw` (or set `enabled: false`) to skip.

## BTV factory (internal)

For BCC apps that resolve streams from the BTV API:

```ts
import { PlayerFactory } from "bccm-video-player"

const factory = new PlayerFactory({
    tokenFactory: null,
    endpoint: "https://api.brunstad.tv/query",
})

await factory.create("player", { episodeId: "865" })
```

## Development

```sh
pnpm i
pnpm dev      # demo at http://localhost:5173
pnpm test     # vitest
pnpm build    # tsc + vite + d.ts
```

## Publishing

Bump `version` in `package.json`, then:

```sh
pnpm publish
```

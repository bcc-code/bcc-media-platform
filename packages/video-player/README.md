# bccm-video-player

HLS video player built on Video.js v10. Custom skin with a settings menu (quality / audio / subtitles / speed), chapter markers, live mode, NPAW analytics, Chromecast and AirPlay.

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

| Option                                 | Type                                      | Notes                                                                                                                                                                                                                                                 |
| -------------------------------------- | ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `src.src`                              | `string`                                  | HLS manifest URL. DASH is not supported — the player builds an `<hlsjs-video>`.                                                                                                                                                                       |
| `autoplay`                             | `boolean`                                 |                                                                                                                                                                                                                                                       |
| `live`                                 | `boolean`                                 | Switches to the live skin: LIVE badge, no seek buttons / time displays / thumbnails.                                                                                                                                                                  |
| `language`                             | `string`                                  | UI language for tooltips, pickers, and error messages. Built-in: `"en"`, `"no"`, `"nl"`, `"de"` (default `"en"`). Unsupported codes fall back to `"en"`. Swap at runtime with `player.setLanguage(...)`. See [Adding a language](#adding-a-language). |
| `languagePreferenceDefaults.audio`     | `string`                                  | 3-letter code, e.g. `"eng"`.                                                                                                                                                                                                                          |
| `languagePreferenceDefaults.subtitles` | `string`                                  | 3-letter code, or omit to disable.                                                                                                                                                                                                                    |
| `subtitles`                            | `Track[]`                                 | External `<track>` descriptors (`src`, `srclang`, `label`, `kind`).                                                                                                                                                                                   |
| `chapters`                             | `Chapter[]`                               | `{ start, duration, title, image? }` in seconds. Renders segment markers on the progress bar and the chapter title while scrubbing; `image` doubles as the scrub preview still.                                                                       |
| `videojs.poster`                       | `string`                                  | Poster image URL.                                                                                                                                                                                                                                     |
| `videojs.crossOrigin`                  | `string`                                  | Defaults to `"anonymous"`.                                                                                                                                                                                                                            |
| `npaw`                                 | `NPAWOptions`                             | See [Analytics](#analytics).                                                                                                                                                                                                                          |
| `onProgress`                           | `(currentTime, duration, player) => void` | Fires on `timeupdate`.                                                                                                                                                                                                                                |

## Player API

```ts
interface Player {
    element: HTMLElement // <video-player> root
    mediaEl: HTMLVideoElement // underlying <hlsjs-video> (use for play/pause/volume/events)
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
| `--bccm-font-family`   | `Inter, system-ui`     | Font stack for all skin text (controls, tooltips, menus, error dialog, native captions). Load the webfont yourself.                    |

In fullscreen the skin scales itself up at 1280 / 1536 / 1920px viewport widths via an internal `--bccm-scale`. Any CSS added to the skin should be a `--bccm-space` multiple or multiplied by `var(--bccm-scale)`, or it won't grow with the rest.

Set on the container:

```html
<div
    id="player"
    style="--bccm-color-accent: #6EB0E6; --bccm-font-family: 'Archivo', sans-serif"
></div>
```

## Adding a language

1. Create `src/video-player/i18n/locales/<code>.ts`:

    ```ts
    import type { LocaleTable } from "../strings"

    const de: LocaleTable = {
        seekBackward: "{seconds} Sekunden zurück",
        seekForward: "{seconds} Sekunden vor",
        // ... TypeScript will fail until every key in LocaleTable is filled in.
    }
    export default de
    ```

2. Register it in `src/video-player/i18n/strings.ts` — three lines: an `import`, an entry in `SUPPORTED_LANGS`, and an entry in `STRINGS`.

3. Add the matching BCP 47 tag to `CORE_LOCALE` in `src/video-player/i18n/core-i18n.ts`. This picks which of Video.js core's shipped locale packs to use for its built-in components, with our wording overlaid on top. Note core has no `no` pack — Norwegian maps to `nb`.

`Record<Lang, ...>` in both files makes it a compile error if any step is missed.

`en.ts` is the canonical reference for which keys exist and how interpolation placeholders (e.g. `{seconds}`, `{height}`, `{label}`) are spelled.

## Keyboard

The settings menu uses Video.js core's menu behaviour:

- `↑ / ↓` — move between items, wrapping
- `Home / End` — first / last item
- `Enter / Space` — select, or open a submenu
- `Esc` — close the menu
- Typing a letter jumps to the next matching item

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

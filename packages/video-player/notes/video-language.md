# Video language (video stream) switching — web player

Port of the `bccm_player` (Flutter) "video language" feature to `packages/video-player`.

Status: **done** — implemented, tested, verified in a browser against a real episode.

## What the feature is

An episode can have several _video_ streams that differ in the video track itself —
burned-in translated text, or a sign-language rendition. They are separate HLS
manifests, not separate audio/subtitle tracks inside one manifest, so switching
means **swapping the source URL**, not selecting a track.

`Stream.videoLanguage` (GraphQL `Language`, nullable) is the discriminator.
`null` = the original version.

## How Flutter does it (reference)

| Piece                                      | Location (`~/Development/code/bcc-media-app`)                                                                                            |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Stream picker                              | `lib/providers/playback_service.dart:334` `getBestStream({videoLanguageCode})`                                                           |
| Selected lang is carried on the media item | `playback_service.dart:190` → `MediaItem.metadata.extras['videoLanguage']` (3-letter code)                                               |
| Settings-menu entry                        | `lib/screens/episode.dart:561` `VideoLanguageSettings`                                                                                   |
| Language list                              | `lib/screens/episode.dart:296` `LinkedHashSet` over `episode.streams.map((e) => e.videoLanguage)` — order of appearance, `null` included |
| Hint that >1 exists                        | `topRightNextToSettingsSlot` → `MultiVideoLangNotice` when `languages.length >= 2`                                                       |

Selection behaviour: on pick, it **re-plays the episode** with the new stream,
passing `playbackPositionMs` from the current controller and `autoplay: true`.
So: position preserved, playback resumes.

`getBestStream` fallback order:
`hls_cmaf`+lang → any `hls_cmaf` → `hls_ts`+lang → any `hls_ts` → first.

Strings (Flutter `l10n`):

| key                 | en                  | nb                      | nl                            | de                   |
| ------------------- | ------------------- | ----------------------- | ----------------------------- | -------------------- |
| `videoTextLanguage` | Video text language | Språk for tekst i video | Taal van de tekst in de video | Textsprache im Video |
| `original`          | Original            | Original                | Origineel                     | Original             |

## What the web player has today

- `PlayerFactory.create()` (`src/btv-player/index.ts`) already accepts a
  **static** `videoLanguage?: string` and picks a matching stream once, at
  creation. There is no runtime switching and no UI.
- `web/src/components/EpisodeViewer.vue:132` passes it from the `?videoLang=`
  query param. That is the only consumer today.
- The episode query (`src/btv-player/api/episode.ts`) already selects
  `videoLanguage` on `streams`.
- `createPlayer()` (`src/video-player/index.ts`) knows nothing about streams —
  it takes a single `src`.
- Settings menu lives in `src/video-player/skin/skin.ts`; submenus for
  quality / audio / subtitles / speed are core radio groups
  (`media-quality-radio-group` etc.) driven by the player store. **There is no
  core radio group for "which source URL"** — this submenu has to be ours.

## Design decisions

1. **Switching lives in `createPlayer`, not only in `PlayerFactory`.**
   The settings menu is in this package's skin, so the core player owns the
   list and the swap. `PlayerFactory` just feeds it the episode's streams.

2. **New options / API** (`src/video-player/index.ts`):

    ```ts
    interface VideoLanguageOption { language: string | null; src: string; label?: string }
    Options.videoLanguages?: VideoLanguageOption[]
    Options.videoLanguage?: string | null        // initial selection
    Player.getVideoLanguages(): VideoLanguageOption[]
    Player.getVideoLanguage(): string | null
    Player.setVideoLanguage(language: string | null): void
    // plus the VIDEO_LANGUAGE_CHANGE_EVENT ("bccm-videolanguagechange") on
    // player.element, so a host can mirror the choice into a URL
    ```

    `language: null` is the original — matches the GraphQL nullability and the
    Flutter model rather than inventing a sentinel string.

3. **The swap assigns `media.src`, not `media.source`.** Per the hlsjs-video
   docs, assigning `src` "replaces the identity half of `source` and leaves
   `type` and the engine options intact". The Hls instance survives
   (`set src` → `engine.loadSource(src)`, see
   `@videojs/media/dist/default/dom/hls-js/hls-js-only.js`), so the persisted
   ABR estimate, the bandwidth listener and the NPAW adapter — all registered
   against that engine — stay live. **This answers the NPAW question: no
   `restartView`.** Same episode, same view; only the manifest changes.

4. **What carries over**: playback position, play/pause state, and the
   _currently selected_ audio and subtitle languages — read off
   `store.audioTrackList.find(t => t.enabled)` and the `showing` text track,
   not from `languagePreferenceDefaults`, which only seed the first load.

5. **UI**: a submenu in the settings menu, rendered only when there are ≥2
   options. Built on core's generic `<media-menu-radio-group>` /
   `<media-menu-radio-item>` — they give `aria-checked`, keyboard nav, a
   bubbling `value-change` event and close-on-select for free. The typed
   groups (`media-quality-radio-group` etc.) are the wrong base: they bind to
   a player-store setting, and "which source URL" is not one.

    One catch: a submenu trigger's `[data-part="hint"]` is written by the
    _core radio group_ inside it, and `MenuElement` **blanks it on every update**
    when nothing publishes metadata. So the hint span carries
    `data-bccm-video-language-hint` instead and `renderVideoLanguageMenu` fills
    it. That function also re-runs on UI-language change, since "Original" is
    translated text.

6. **Ordering is ours, not the API's.** `episodes.resolvers.go:156` builds the
   translated streams by `range`-ing a Go map, so `episode.streams` comes back
   shuffled and the menu would reorder itself on every page load. The factory
   sorts: original first, then by native name (UI-language independent).
   _This is a deliberate divergence from Flutter_, which takes the API order.

7. **Label wording** follows the Flutter l10n table above verbatim, so the two
   players name the same setting the same way.

## Files

| File                                             | What                                                                                    |
| ------------------------------------------------ | --------------------------------------------------------------------------------------- |
| `src/video-player/utils/video-language.ts`       | `VideoLanguageOption`, normalize / dedupe / find / label / menu-value helpers (+ tests) |
| `src/video-player/skin/skin.ts`                  | the settings row, the submenu, `renderVideoLanguageMenu`                                |
| `src/video-player/skin/icons/video-language.svg` | screen frame around the translate glyph — distinct from the audio row's bare one        |
| `src/video-player/index.ts`                      | options, `get/setVideoLanguage`, the swap, `VIDEO_LANGUAGE_CHANGE_EVENT`                |
| `src/video-player/i18n/*`                        | `videoLanguage`, `videoLanguageActive`, `videoLanguageOriginal` in en/no/nl/de          |
| `src/btv-player/streams.ts`                      | `toVideoLanguageOptions` — streams → options (+ tests)                                  |
| `src/btv-player/index.ts`                        | factory passes the list through                                                         |
| `src/btv-player/api/episode.ts`                  | `videoLanguage` typed nullable (it always was, in the schema)                           |

## Verified

Driven in Chrome against episode `7c5d64bf-e80a-470f-b749-845a4cee296c`
("Bible Kids Day", 15 video languages):

- row reads `Video text language — Original`, 15 options + Original, correct
  one checked;
- order is alphabetical and identical across loads;
- switching at t=26s resumed at t≈29s after 4s, still playing, new manifest URL;
- `bccm-videolanguagechange` fired with the new code;
- `getVideoLanguage()` and the row hint both followed.

## Following the viewer's language

Second ask: embeds and the site should _start_ on the viewer's own language
rather than always on the original.

Code formats are the catch. The site picker and `SUPPORT_LOCALES`
(`web/src/i18n/index.ts`) are 2-letter — `en, no, da, nl, de, bg, es, fi, fr,
hu, it, pl, pt, ro, ru, sl, tr` — and `Stream.videoLanguage` comes back 2-letter
too (`es`, `it`, `no`…), so those match directly. But `languageTo3letter`
(`web/src/utils/languages.ts`) converts to ISO 639-2 for the audio/subtitle
preferences, and the embed's `?language=` is run through it, so a 3-letter code
reaches the player as well.

So `findVideoLanguageOption` now matches **canonically**:
`canonicalVideoLanguage` runs the code through `new Intl.Locale(x).language`,
which folds every 3-letter spelling onto its 2-letter base — bibliographic
variants included (`ger`/`deu` → `de`, `dut`/`nld` → `nl`, `fre`/`fra` → `fr`).
Bokmål and Nynorsk are then mapped onto `no` by hand, since Intl keeps them
apart and BCC content doesn't. An exact match still wins over a canonical one.
`dedupeVideoLanguages` and `toVideoLanguageOptions` key on the canonical code
too, so a list carrying both `no` and `nor` yields one row.

Wiring on the web side:

| File                                       | Change                                                                                                      |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| `web/src/components/EpisodeViewer.vue:130` | `videoLanguage: route.query.videoLang \|\| uiLang` — `?videoLang` still wins                                |
| `web/src/pages/EpisodeEmbed.vue`           | new `videoLanguage` ref: `?videoLang` \|\| the **raw** `?language` (not the 3-letter form `language` holds) |

Behaviour change worth knowing: a Dutch viewer now gets the Dutch-text version
of an episode by default, where before everyone got the original.

### Verified (embed, prod API, `bccm-video-player@3.5.1`)

Episode `7c5d64bf-e80a-470f-b749-845a4cee296c` — 15 video languages.

| URL                         | Video language               |
| --------------------------- | ---------------------------- |
| no params                   | Original                     |
| `?language=nl`              | Nederlands                   |
| `?language=nld`             | Nederlands                   |
| `?language=nb`              | Norsk                        |
| `?language=nor`             | Norsk                        |
| `?language=ger`             | Deutsch                      |
| `?language=de&videoLang=fr` | Français — the override wins |
| `?language=sv`              | Original — graceful fallback |
| `?videoLang=ron`            | Română                       |

Canonical matching also confirmed through the player API directly:
`nld`/`dut` → `nl`, `deu`/`ger` → `de`, `nor`/`nb` → `no`, `fra` → `fr`, and an
unknown code leaves the current selection untouched (`setVideoLanguage` ignores
what it can't resolve, unlike the initial `videoLanguage` option, which falls
back to the original so there is always something to play).

> `web` consumes the **published** package, not the workspace. The canonical
> matcher shipped in 3.5.1, which `web/package.json` now pins (`^3.5.1`).

## Downloads do NOT follow the video language

Checked after the player work. Answer: **no** — a download always gives the
original video, whatever is playing. Three independent layers, each of which
would have to change:

1. **`File.videoLanguage` is always `null`.** The field exists in the schema
   (`backend/graph/api/schema/episodes.graphqls:91`) but `FileFrom`
   (`backend/graph/api/model/asset.go:44`) never sets it — compare the streams
   path, where `episodes.resolvers.go:169` assigns
   `stream.VideoLanguage = &languageKey`.

2. **The query only reaches the primary asset.** `getFilesForEpisodes`
   (`queries/assets.sql:1`) joins
   `episodes → mediaitems → assets ON mi.asset_id = a.id`, so it returns files
   for the episode's own asset only. The `Streams` resolver additionally loops
   `for lang, assetID := range e.Assets` (`episodes.resolvers.go:156`); `Files`
   (`:187`) has no such loop.

3. **The UI ignores it.** `EmbedDownloadables.vue` — used by the embed _and_ the
   main episode page (`EpisodeDisplay.vue:391`) — doesn't select
   `videoLanguage` in `getEpisodeEmbed` / `getEpisode`
   (`web/src/graph/queries/episode.graphql:80,156`), and both its language
   dropdown and its file filter key purely on `audioLanguage`.

Confirmed against prod: episode `7c5d64bf…` has 15 video-language _streams_ but
returns 2 _files_, both `videoLanguage: null`, both the Norwegian original.

**Open question before any of this is worth doing:** do the per-language assets
even have `assetfiles` rows? If the translated renditions were only ever
packaged for streaming, layer 2 returns nothing and the work is moot. Check the
DB / CMS first.

## Follow-ups (not done)

- `web/src/components/EpisodeViewer.vue:132` still only _reads_ `?videoLang`.
  It could listen for `bccm-videolanguagechange` and write the choice back to
  the query param, so a switch survives a reload / is shareable.
- Flutter shows a `MultiVideoLangNotice` next to the settings button when an
  episode has >1 language. No equivalent here; the row itself is the only cue.
- Nothing remembers the choice across episodes — Flutter carries it through a
  playlist via `currentMediaItem.extras['videoLanguage']`.

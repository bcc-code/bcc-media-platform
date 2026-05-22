// UI string tables for the video player.
//
// Adding a language: drop a file into `./locales/`. The filename is the
// language code (`de.ts` → `"de"`). Default-export a `LocaleTable`. The
// glob below picks it up at build time — no other file needs editing.
//
// Adding a string key: extend the `StringKey` union and the `LocaleTable`
// interface in this file, then fill in every locale file (TypeScript will
// complain at each one that's missing the new key).

export type StringKey =
    | "seekBackward"
    | "seekForward"
    | "goToLive"
    | "live"
    | "playbackSpeed"
    | "playbackSpeedActive"
    | "audio"
    | "audioLanguage"
    | "audioLanguageActive"
    | "audioTrackFallback"
    | "subtitles"
    | "subtitlesActive"
    | "subtitlesOff"
    | "off"
    | "subtitleTrackFallback"
    | "quality"
    | "videoQuality"
    | "videoQualityActive"
    | "videoQualityAuto"
    | "auto"
    | "autoWithHeight"
    | "qualityLevelFallback"
    | "hideControls"
    | "sessionExpired"
    | "sessionExpiredDesc"
    | "somethingWentWrong"
    | "ok"
    | "play"
    | "pause"
    | "replay"
    | "mute"
    | "unmute"
    | "enterFullscreen"
    | "exitFullscreen"
    | "enterPip"
    | "exitPip"
    | "startCasting"
    | "stopCasting"
    | "connecting"

export type LocaleTable = Record<StringKey, string>

// A language code. Validity is enforced at runtime by `isSupportedLang`,
// which consults the locale registry assembled from `./locales/*.ts`.
// Kept as `string` (rather than a union literal) so contributors can add a
// language with a single new file — see the comment at the top of this file.
export type Lang = string
export const DEFAULT_LANG: Lang = "en"

export const LANGUAGE_CHANGE_EVENT = "bccm-languagechange"

// Vite resolves this glob at build time into static imports of every file
// under ./locales/. The output bundle contains all locales — adding a new
// locale file is the only change needed to ship it.
const modules = import.meta.glob<{ default: LocaleTable }>("./locales/*.ts", {
    eager: true,
})

const STRINGS: Record<string, LocaleTable> = {}
for (const [path, mod] of Object.entries(modules)) {
    const code = path.match(/\/([^/]+)\.ts$/)?.[1]
    if (code) STRINGS[code] = mod.default
}

export const SUPPORTED_LANGS: readonly Lang[] = Object.keys(STRINGS).sort()

export function isSupportedLang(value: unknown): value is Lang {
    return typeof value === "string" && value in STRINGS
}

export function t(
    lang: Lang | undefined,
    key: StringKey,
    params?: Record<string, string | number>
): string {
    const table =
        (lang != null && STRINGS[lang]) || STRINGS[DEFAULT_LANG] || undefined
    const tmpl = table?.[key] ?? STRINGS[DEFAULT_LANG]?.[key] ?? key
    if (!params) return tmpl
    return tmpl.replace(/\{(\w+)\}/g, (_, name) =>
        params[name] != null ? String(params[name]) : `{${name}}`
    )
}

export function getLanguage(el: Element | null | undefined): Lang {
    const root = el?.closest("video-player") as HTMLElement | null
    const v = root?.getAttribute("data-lang")
    return isSupportedLang(v) ? v : DEFAULT_LANG
}

// Wire a custom element to the player root's `bccm-languagechange` event,
// scoped to the element's lifecycle via `signal`. Callers don't need to know
// the event name or how the root is located.
export function onLanguageChange(
    el: Element,
    signal: AbortSignal,
    cb: (lang: Lang) => void
): void {
    const root = el.closest("video-player")
    root?.addEventListener(LANGUAGE_CHANGE_EVENT, () => cb(getLanguage(el)), {
        signal,
    })
}

// Walks `[data-i18n]` nodes under `root` and rewrites their textContent
// using the current language. Used by skin/skin.ts after building the DOM
// and again from createPlayer's setLanguage() when the language changes.
//
// Markup contract:
//   <span data-i18n="audio"></span>
//   <span data-i18n="seekBackward" data-i18n-params='{"seconds":15}'></span>
export function relabelSkin(root: Element, lang: Lang): void {
    const nodes = root.querySelectorAll<HTMLElement>("[data-i18n]")
    nodes.forEach((el) => {
        const key = el.getAttribute("data-i18n") as StringKey | null
        if (!key) return
        const raw = el.getAttribute("data-i18n-params")
        let params: Record<string, string | number> | undefined
        if (raw) {
            try {
                params = JSON.parse(raw) as Record<string, string | number>
            } catch {
                params = undefined
            }
        }
        el.textContent = t(lang, key, params)
    })
}

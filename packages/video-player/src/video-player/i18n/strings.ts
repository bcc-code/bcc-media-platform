// UI string tables for the video player.
//
// Adding a language: create `./locales/<code>.ts` (default-export a
// `LocaleTable`), then register it here in three places: the import, the
// SUPPORTED_LANGS array, and the STRINGS registry. `Record<Lang, ...>` makes
// it a compile error if you skip any one of them.
//
// Adding a string key: extend `StringKey` and `LocaleTable` here; every
// locale file gets a compile error until you fill the new key in.

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

import en from "./locales/en"
import no from "./locales/no"
import nl from "./locales/nl"
import de from "./locales/de"

export const SUPPORTED_LANGS = ["en", "no", "nl", "de"] as const
export type Lang = (typeof SUPPORTED_LANGS)[number]
export const DEFAULT_LANG: Lang = "en"

export const LANGUAGE_CHANGE_EVENT = "bccm-languagechange"

// `Record<Lang, LocaleTable>` enforces that every entry in SUPPORTED_LANGS
// has a registered table, and that every registered code is in the union.
const STRINGS: Record<Lang, LocaleTable> = { en, no, nl, de }

export function isSupportedLang(value: unknown): value is Lang {
    return (
        typeof value === "string" &&
        (SUPPORTED_LANGS as readonly string[]).includes(value)
    )
}

export function t(
    lang: Lang | undefined,
    key: StringKey,
    params?: Record<string, string | number>
): string {
    const table = (lang && STRINGS[lang]) || STRINGS[DEFAULT_LANG]
    const tmpl = table[key] ?? STRINGS[DEFAULT_LANG][key] ?? key
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

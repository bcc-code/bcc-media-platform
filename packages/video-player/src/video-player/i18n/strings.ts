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
    | "languageName"
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

// Each locale's name in its own writing system — "English", "Norsk",
// "Nederlands", "Deutsch". Use this in language pickers so a user who can't
// read the current UI still recognizes their language. (Matches YouTube /
// Netflix / Vimeo convention.)
export function getLanguageName(lang: Lang): string {
    return t(lang, "languageName")
}

// Resolve a media-track language code (BCP-47 "en" / ISO 639-2 "eng" /
// "en-US") to its native name: track "no" → "Norsk", "de" → "Deutsch",
// "fr" → "Français". Returns undefined for unrecognized codes so callers
// can fall back to whatever name the manifest supplied.
//
// The track picker uses this so a user who can't read the current UI still
// recognizes their language — the same logic that drives the UI language
// switcher (matches YouTube / Netflix). For lowercase-by-default scripts
// (Norwegian "norsk", French "français") the first letter is uppercased so
// the picker reads as a standalone label rather than mid-sentence prose.
export function getTrackLanguageName(
    code: string | undefined | null
): string | undefined {
    if (!code) return undefined
    try {
        const tag = code.replace(/_/g, "-")
        const dn = new Intl.DisplayNames([tag], {
            type: "language",
            fallback: "none",
        })
        const name = dn.of(tag)
        if (!name) return undefined
        return name.charAt(0).toLocaleUpperCase(tag) + name.slice(1)
    } catch {
        return undefined
    }
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

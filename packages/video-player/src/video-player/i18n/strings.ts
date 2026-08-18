// A new language needs registering in three places here — the import,
// SUPPORTED_LANGS and STRINGS — and missing any one is a compile error.

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
    | "startAirplay"
    | "stopAirplay"
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

export const STRINGS: Record<Lang, LocaleTable> = { en, no, nl, de }

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

// Each locale's name in its own writing system, so a user who can't read the
// current UI still recognizes their language.
export function getLanguageName(lang: Lang): string {
    return t(lang, "languageName")
}

// Native name for a track's language code ("eng" → "English"), undefined when
// unrecognized so callers can fall back to the manifest's own label. Scripts
// that are lowercase by default ("norsk") get their first letter uppercased.
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

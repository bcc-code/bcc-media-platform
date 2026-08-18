import { registerI18n } from "@videojs/core/i18n"
import coreDe from "@videojs/core/i18n/locales/de"
import coreEn from "@videojs/core/i18n/locales/en"
import coreNb from "@videojs/core/i18n/locales/nb"
import coreNl from "@videojs/core/i18n/locales/nl"
import {
    type Lang,
    type LocaleTable,
    STRINGS,
    SUPPORTED_LANGS,
} from "./strings"

// Core ships Norwegian as nb/nn — a plain "no" tag has no pack and resolves
// straight to English.
const CORE_LOCALE: Record<Lang, string> = {
    en: "en",
    no: "nb",
    nl: "nl",
    de: "de",
}

export function toCoreLocale(lang: Lang): string {
    return CORE_LOCALE[lang]
}

type Group = Record<string, string>
type Pack = Record<string, Group>

// Bundled rather than lazy-loaded: registerI18n makes loadLocale skip the
// shipped pack for that tag, so the pack has to be the base we merge onto or
// the keys we don't override would go untranslated.
const CORE_PACKS: Record<Lang, Pack> = {
    en: coreEn as Pack,
    no: coreNb as Pack,
    nl: coreNl as Pack,
    de: coreDe as Pack,
}

// Our wording for the strings we already maintain; core's pack covers the rest
// (menu, time, volume and status labels).
function overlay(t: LocaleTable): Pack {
    return {
        buttons: {
            play: t.play,
            pause: t.pause,
            replay: t.replay,
            mute: t.mute,
            unmute: t.unmute,
        },
        seek: { forward: t.seekForward, backward: t.seekBackward },
        fullscreen: { enter: t.enterFullscreen, exit: t.exitFullscreen },
        pip: { enter: t.enterPip, exit: t.exitPip },
        cast: {
            start: t.startCasting,
            stop: t.stopCasting,
            connecting: t.connecting,
        },
        airplay: { start: t.startAirplay, stop: t.stopAirplay },
        live: { badge: t.live, seekToEdge: t.goToLive },
        errors: { title: t.somethingWentWrong },
        common: { ok: t.ok },
    }
}

function mergeGroups(base: Pack, over: Pack): Pack {
    const out: Pack = { ...base }
    for (const [group, values] of Object.entries(over)) {
        out[group] = { ...base[group], ...values }
    }
    return out
}

let registered = false

// The registry is realm-global, so this only needs to run once per page.
export function registerCoreTranslations(): void {
    if (registered) return
    registered = true
    for (const lang of SUPPORTED_LANGS) {
        registerI18n(
            toCoreLocale(lang),
            mergeGroups(CORE_PACKS[lang], overlay(STRINGS[lang]))
        )
    }
}

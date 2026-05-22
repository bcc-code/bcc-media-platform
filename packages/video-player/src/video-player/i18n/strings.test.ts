import { describe, expect, it } from "vitest"
import {
    DEFAULT_LANG,
    isSupportedLang,
    SUPPORTED_LANGS,
    t,
    type Lang,
    type StringKey,
} from "./strings"
import en from "./locales/en"

const PLACEHOLDER_RE = /\{(\w+)\}/g
function placeholdersIn(s: string): Set<string> {
    return new Set(Array.from(s.matchAll(PLACEHOLDER_RE), (m) => m[1]))
}

describe("t()", () => {
    it("returns the template verbatim when there are no params", () => {
        expect(t("en", "off")).toBe("Off")
    })

    it("interpolates a {placeholder} with the matching param", () => {
        expect(t("en", "seekBackward", { seconds: 15 })).toBe(
            "Seek backward 15 seconds"
        )
    })

    it("stringifies numeric params", () => {
        expect(t("en", "audioTrackFallback", { id: 3 })).toBe("Track 3")
    })

    it("interpolates falsy-but-defined params (0)", () => {
        expect(t("en", "seekForward", { seconds: 0 })).toBe(
            "Seek forward 0 seconds"
        )
    })

    it("leaves a placeholder intact when its param is missing", () => {
        expect(t("en", "seekBackward")).toContain("{seconds}")
    })

    it("falls back to en for an unsupported lang code", () => {
        // Lang is a literal union now; deliberately pass an invalid value to
        // exercise the runtime defense.
        expect(t("zz" as Lang, "off")).toBe("Off")
    })

    it("falls back to en for an undefined lang", () => {
        expect(t(undefined, "off")).toBe("Off")
    })

    it("returns the key verbatim if it doesn't exist in en either", () => {
        expect(t("en", "nonexistent" as StringKey)).toBe("nonexistent")
    })

    it("uses the translated string for a registered lang", () => {
        expect(t("no", "off")).toBe("Av")
        expect(t("nl", "off")).toBe("Uit")
    })

    it("interpolates in non-en locales", () => {
        expect(t("nl", "seekBackward", { seconds: 30 })).toBe(
            "30 seconden terug"
        )
    })
})

describe("locale placeholder parity", () => {
    // Catches the failure mode TypeScript can't: a translator dropping
    // `{seconds}` from "Spol {seconds} sekunder tilbake" — build passes, but
    // the count never renders. For every key in `en`, every other locale
    // must declare the same set of placeholder names.
    it("every non-en locale preserves the same {placeholders} as en for each key", () => {
        const keys = Object.keys(en) as StringKey[]
        const otherLangs = SUPPORTED_LANGS.filter((l) => l !== DEFAULT_LANG)
        const mismatches: string[] = []

        for (const key of keys) {
            const expected = placeholdersIn(t("en", key))
            for (const lang of otherLangs) {
                const actual = placeholdersIn(t(lang, key))
                const missing = [...expected].filter((p) => !actual.has(p))
                const extra = [...actual].filter((p) => !expected.has(p))
                if (missing.length || extra.length) {
                    mismatches.push(
                        `${lang}.${key}: missing=${JSON.stringify(missing)} extra=${JSON.stringify(extra)}`
                    )
                }
            }
        }

        expect(mismatches).toEqual([])
    })
})

describe("isSupportedLang()", () => {
    it("returns true for every registered language", () => {
        for (const l of SUPPORTED_LANGS) {
            expect(isSupportedLang(l)).toBe(true)
        }
    })

    it("returns false for unregistered codes", () => {
        expect(isSupportedLang("zz")).toBe(false)
        expect(isSupportedLang("")).toBe(false)
        expect(isSupportedLang("EN")).toBe(false) // case-sensitive by design
    })

    it("returns false for non-string values", () => {
        expect(isSupportedLang(undefined)).toBe(false)
        expect(isSupportedLang(null)).toBe(false)
        expect(isSupportedLang(123)).toBe(false)
        expect(isSupportedLang({})).toBe(false)
    })
})

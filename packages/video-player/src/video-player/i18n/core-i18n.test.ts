import { describe, expect, it } from "vitest"
import { getI18nTranslations } from "@videojs/core/i18n"
import { registerCoreTranslations, toCoreLocale } from "./core-i18n"
import { SUPPORTED_LANGS } from "./strings"

// Core ships no locale pack for the "no" macrolanguage, so an unmapped tag
// silently falls back to English rather than failing.
describe("toCoreLocale", () => {
    it("maps Norwegian onto core's nb pack", () => {
        expect(toCoreLocale("no")).toBe("nb")
    })

    it("covers every supported language", () => {
        for (const lang of SUPPORTED_LANGS) {
            expect(toCoreLocale(lang)).toBeTruthy()
        }
    })
})

describe("registerCoreTranslations", () => {
    registerCoreTranslations()

    it("overrides core's wording with ours", () => {
        // Core's own nb pack says "Start sending".
        expect(getI18nTranslations("nb")["cast.start"]).toBe("Start casting")
    })

    it("keeps core's pack for keys we don't override", () => {
        // Registering a tag stops the shipped pack from lazy-loading, so these
        // only survive because we merge onto it.
        for (const lang of SUPPORTED_LANGS) {
            const table = getI18nTranslations(toCoreLocale(lang))
            expect(table["menu.quality"]).toBeTruthy()
            expect(table["volume.label"]).toBeTruthy()
            expect(table["time.duration"]).toBeTruthy()
            expect(table["errors.network"]).toBeTruthy()
        }
    })
})

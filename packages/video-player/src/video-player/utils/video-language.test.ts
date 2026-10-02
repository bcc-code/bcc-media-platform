import { describe, expect, it } from "vitest"
import {
    canonicalVideoLanguage,
    dedupeVideoLanguages,
    findVideoLanguageOption,
    normalizeVideoLanguage,
    videoLanguageFromValue,
    videoLanguageLabel,
    videoLanguageValue,
} from "./video-language"

describe("normalizeVideoLanguage", () => {
    it("lowercases and trims", () => {
        expect(normalizeVideoLanguage(" NOR ")).toBe("nor")
    })

    it("reads absent and blank codes as the original", () => {
        expect(normalizeVideoLanguage(null)).toBeNull()
        expect(normalizeVideoLanguage(undefined)).toBeNull()
        expect(normalizeVideoLanguage("   ")).toBeNull()
    })
})

describe("canonicalVideoLanguage", () => {
    it("folds a three-letter code onto its two-letter form", () => {
        expect(canonicalVideoLanguage("nor")).toBe("no")
        expect(canonicalVideoLanguage("deu")).toBe("de")
        expect(canonicalVideoLanguage("spa")).toBe("es")
    })

    it("folds the bibliographic spellings too", () => {
        expect(canonicalVideoLanguage("ger")).toBe("de")
        expect(canonicalVideoLanguage("dut")).toBe("nl")
        expect(canonicalVideoLanguage("fre")).toBe("fr")
    })

    it("treats Bokmål and Nynorsk as Norwegian", () => {
        expect(canonicalVideoLanguage("nb")).toBe("no")
        expect(canonicalVideoLanguage("nob")).toBe("no")
        expect(canonicalVideoLanguage("nn")).toBe("no")
    })

    it("leaves a code with no two-letter form alone", () => {
        expect(canonicalVideoLanguage("yue")).toBe("yue")
        expect(canonicalVideoLanguage("kha")).toBe("kha")
    })

    it("reads absent and blank codes as the original", () => {
        expect(canonicalVideoLanguage(null)).toBeNull()
        expect(canonicalVideoLanguage("  ")).toBeNull()
    })
})

describe("dedupeVideoLanguages", () => {
    it("keeps the first of each language and preserves order", () => {
        expect(
            dedupeVideoLanguages([
                { language: null, src: "orig" },
                { language: "nor", src: "nor-cmaf" },
                { language: "NOR", src: "nor-ts" },
            ])
        ).toEqual([
            { language: null, src: "orig" },
            { language: "nor", src: "nor-cmaf" },
        ])
    })

    it("collapses two spellings of one language into a single row", () => {
        expect(
            dedupeVideoLanguages([
                { language: "no", src: "two-letter" },
                { language: "nor", src: "three-letter" },
            ])
        ).toEqual([{ language: "no", src: "two-letter" }])
    })

    it("drops entries with nothing to play", () => {
        expect(
            dedupeVideoLanguages([
                { language: "nor", src: "" },
                { language: "deu", src: "deu" },
            ])
        ).toEqual([{ language: "deu", src: "deu" }])
    })
})

describe("findVideoLanguageOption", () => {
    const options = [
        { language: null, src: "orig" },
        { language: "nor", src: "nor" },
    ]

    it("matches case-insensitively", () => {
        expect(findVideoLanguageOption(options, "NOR")?.src).toBe("nor")
    })

    it("resolves a blank or absent code to the original", () => {
        expect(findVideoLanguageOption(options, null)?.src).toBe("orig")
        expect(findVideoLanguageOption(options, "")?.src).toBe("orig")
    })

    it("returns undefined for a language the episode doesn't have", () => {
        expect(findVideoLanguageOption(options, "deu")).toBeUndefined()
    })

    it("matches a three-letter preference against a two-letter option", () => {
        // What the apps actually do: the site picker holds "no"/"nb" and
        // languageTo3letter turns it into "nor", while the API says "no".
        expect(findVideoLanguageOption(options, "nor")?.src).toBe("nor")
        expect(findVideoLanguageOption(options, "nb")?.src).toBe("nor")
    })

    it("matches a two-letter preference against a three-letter option", () => {
        const threeLetter = [
            { language: null, src: "orig" },
            { language: "deu", src: "de" },
        ]
        expect(findVideoLanguageOption(threeLetter, "de")?.src).toBe("de")
    })

    it("prefers an exact match over a canonical one", () => {
        const both = [
            { language: "nor", src: "three-letter" },
            { language: "no", src: "two-letter" },
        ]
        expect(findVideoLanguageOption(both, "no")?.src).toBe("two-letter")
        expect(findVideoLanguageOption(both, "nor")?.src).toBe("three-letter")
    })
})

describe("videoLanguageValue", () => {
    it("round-trips through the menu's string values", () => {
        expect(videoLanguageFromValue(videoLanguageValue("nor"))).toBe("nor")
        expect(videoLanguageFromValue(videoLanguageValue(null))).toBeNull()
    })

    it("encodes the original as the empty string", () => {
        expect(videoLanguageValue(null)).toBe("")
    })
})

describe("videoLanguageLabel", () => {
    it("names the language in its own writing system", () => {
        expect(videoLanguageLabel({ language: "nor", src: "x" }, "en")).toBe(
            "Norsk"
        )
    })

    it("uses the UI language's word for the original", () => {
        expect(videoLanguageLabel({ language: null, src: "x" }, "en")).toBe(
            "Original"
        )
        expect(videoLanguageLabel({ language: null, src: "x" }, "nl")).toBe(
            "Origineel"
        )
    })

    it("prefers an explicit label", () => {
        expect(
            videoLanguageLabel(
                { language: "nor", src: "x", label: "Tegnspråk" },
                "en"
            )
        ).toBe("Tegnspråk")
    })

    it("falls back to the raw code when it names no known language", () => {
        expect(videoLanguageLabel({ language: "qqq", src: "x" }, "en")).toBe(
            "qqq"
        )
    })
})

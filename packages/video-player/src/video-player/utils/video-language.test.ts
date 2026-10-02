import { describe, expect, it } from "vitest"
import {
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

import { describe, expect, it } from "vitest"
import {
    threeLetterCodeToName,
    threeLetterCodeToTwoLetterCode,
    twoLetterCodeToThreeLetterCode,
} from "./localeMapper"

describe("threeLetterCodeToName", () => {
    it.each([
        ["ENG", "English"],
        ["DEU", "Deutsch"],
        ["GER", "Deutsch"],
        ["NOR", "Norsk"],
        ["NLD", "Nederlands"],
        ["DUT", "Nederlands"],
        ["FRA", "Français"],
        ["FRE", "Français"],
        ["ZHS", "汉语"],
        ["YUE", "汉语"],
    ])("maps %s to %s", (code, expected) => {
        expect(threeLetterCodeToName(code)).toBe(expected)
    })

    it("is case-insensitive", () => {
        expect(threeLetterCodeToName("eng")).toBe("English")
        expect(threeLetterCodeToName("Eng")).toBe("English")
    })

    it("returns null for unknown codes", () => {
        expect(threeLetterCodeToName("xxx")).toBeNull()
    })

    it("returns null for empty / undefined input", () => {
        expect(threeLetterCodeToName("")).toBeNull()
        expect(threeLetterCodeToName(undefined as unknown as string)).toBeNull()
    })
})

describe("threeLetterCodeToTwoLetterCode", () => {
    it.each([
        ["ENG", "en"],
        ["DEU", "de"],
        ["GER", "de"],
        ["NOR", "no"],
        ["FRA", "fr"],
        ["FRE", "fr"],
        ["RON", "ro"],
        ["RUM", "ro"],
        ["CES", "cz"],
        ["CZE", "cz"],
    ])("maps %s to %s", (code, expected) => {
        expect(threeLetterCodeToTwoLetterCode(code)).toBe(expected)
    })

    it("returns null for unknown codes", () => {
        expect(threeLetterCodeToTwoLetterCode("xxx")).toBeNull()
    })
})

describe("twoLetterCodeToThreeLetterCode", () => {
    it.each([
        ["en", "eng"],
        ["de", "deu"],
        ["no", "nor"],
        ["fr", "fra"],
        ["ro", "ron"],
        // both Czech aliases collapse to the canonical 3-letter code
        ["cs", "ces"],
        ["cz", "ces"],
        // tk preserved despite being Turkmen — kept for backward-compat
        ["tr", "tur"],
        ["tk", "tur"],
    ])("maps %s to %s", (code, expected) => {
        expect(twoLetterCodeToThreeLetterCode(code)).toBe(expected)
    })

    it("is case-insensitive", () => {
        expect(twoLetterCodeToThreeLetterCode("EN")).toBe("eng")
    })

    it("returns 'und' (undefined language) for unknown codes", () => {
        expect(twoLetterCodeToThreeLetterCode("xx")).toBe("und")
        expect(twoLetterCodeToThreeLetterCode("")).toBe("und")
    })
})

describe("round-trip stability", () => {
    // Codes that round-trip cleanly via the canonical 3-letter code. Excludes
    // pairs like GER/DEU which collapse to one canonical 3-letter form.
    const codes = ["en", "de", "no", "nl", "fr", "es", "fi", "ru", "pt", "pl"]
    it.each(codes)("two→three→two preserves %s", (twoLetter) => {
        const three = twoLetterCodeToThreeLetterCode(twoLetter)
        expect(three).not.toBe("und")
        expect(threeLetterCodeToTwoLetterCode(three!)).toBe(twoLetter)
    })
})

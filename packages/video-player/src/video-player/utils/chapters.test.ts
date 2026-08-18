import { describe, expect, it } from "vitest"
import { type Chapter, toChaptersVTT, toThumbnailsVTT } from "./chapters"

const chapters: Chapter[] = [
    { start: 0, duration: 65.5, title: "Intro", image: "https://x/1.jpg" },
    { start: 65.5, duration: 3600, title: "Main", image: null },
]

describe("toChaptersVTT", () => {
    it("emits one cue per chapter with hh:mm:ss.mmm timestamps", () => {
        expect(toChaptersVTT(chapters)).toBe(
            "WEBVTT\n\n" +
                "00:00:00.000 --> 00:01:05.500\nIntro\n\n" +
                "00:01:05.500 --> 01:01:05.500\nMain\n"
        )
    })

    it("returns empty when there is nothing to render", () => {
        expect(toChaptersVTT([])).toBe("")
        expect(toChaptersVTT([{ start: 0, duration: 0, title: "Zero" }])).toBe(
            ""
        )
    })

    it("flattens newlines, which would otherwise split the cue", () => {
        const vtt = toChaptersVTT([
            { start: 0, duration: 10, title: "Two\nlines" },
        ])
        expect(vtt).toContain("Two lines")
    })
})

describe("toThumbnailsVTT", () => {
    it("only includes chapters that have a still", () => {
        const vtt = toThumbnailsVTT(chapters)
        expect(vtt).toContain("https://x/1.jpg")
        expect(vtt.split("-->").length - 1).toBe(1)
    })

    it("returns empty when no chapter has an image", () => {
        expect(toThumbnailsVTT([{ start: 0, duration: 10, title: "A" }])).toBe(
            ""
        )
    })
})

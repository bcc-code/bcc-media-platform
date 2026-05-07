import { describe, expect, it } from "vitest"
import { getDefaults, mergeOptions } from "./options"

describe("getDefaults", () => {
    it("returns a fresh object each call (callers may mutate)", () => {
        const a = getDefaults()
        const b = getDefaults()
        expect(a).not.toBe(b)
        expect(a).toEqual(b)
    })

    it("seeds the documented defaults", () => {
        expect(getDefaults()).toEqual({
            src: { type: "application/x-mpegURL" },
            autoplay: false,
            languagePreferenceDefaults: {},
            subtitles: [],
            videojs: { crossOrigin: "anonymous" },
        })
    })
})

describe("mergeOptions", () => {
    it("override shallow-replaces top-level scalars", () => {
        const merged = mergeOptions(getDefaults(), { autoplay: true })
        expect(merged.autoplay).toBe(true)
        expect(merged.subtitles).toEqual([]) // untouched
    })

    it("deep-merges `src`", () => {
        const merged = mergeOptions(getDefaults(), {
            src: { src: "https://example.com/stream.m3u8" },
        })
        expect(merged.src).toEqual({
            type: "application/x-mpegURL",
            src: "https://example.com/stream.m3u8",
        })
    })

    it("deep-merges `videojs`", () => {
        const merged = mergeOptions(getDefaults(), {
            videojs: { poster: "poster.jpg" },
        })
        expect(merged.videojs).toEqual({
            crossOrigin: "anonymous",
            poster: "poster.jpg",
        })
    })

    it("deep-merges `languagePreferenceDefaults`", () => {
        const base = mergeOptions(getDefaults(), {
            languagePreferenceDefaults: { audio: "eng" },
        })
        const merged = mergeOptions(base, {
            languagePreferenceDefaults: { subtitles: "nor" },
        })
        expect(merged.languagePreferenceDefaults).toEqual({
            audio: "eng",
            subtitles: "nor",
        })
    })

    it("override values in deep-merged keys win over base", () => {
        const merged = mergeOptions(getDefaults(), {
            videojs: { crossOrigin: "use-credentials" },
        })
        expect(merged.videojs.crossOrigin).toBe("use-credentials")
    })

    it("missing override deep-merge keys leave the base intact", () => {
        const base = mergeOptions(getDefaults(), {
            languagePreferenceDefaults: { audio: "eng" },
        })
        const merged = mergeOptions(base, { autoplay: true })
        expect(merged.languagePreferenceDefaults).toEqual({ audio: "eng" })
    })
})

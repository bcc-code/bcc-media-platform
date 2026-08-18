import { describe, expect, it } from "vitest"
import { getDefaults, mergeOptions, normalizeSourceType } from "./options"

describe("normalizeSourceType", () => {
    it("maps the v8-era HLS spelling onto the canonical constant", () => {
        expect(normalizeSourceType("application/x-mpegURL")).toBe(
            "application/vnd.apple.mpegurl"
        )
    })

    it("accepts the canonical spellings and is case/space insensitive", () => {
        expect(normalizeSourceType("application/vnd.apple.mpegurl")).toBe(
            "application/vnd.apple.mpegurl"
        )
        expect(normalizeSourceType(" VND.APPLE.MPEGURL ")).toBe(
            "application/vnd.apple.mpegurl"
        )
        expect(normalizeSourceType("Video/MP4")).toBe("video/mp4")
    })

    it("drops unknown or absent types so the element infers from the URL", () => {
        expect(normalizeSourceType(undefined)).toBeUndefined()
        expect(normalizeSourceType("")).toBeUndefined()
        expect(normalizeSourceType("application/dash+xml")).toBeUndefined()
    })
})

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
            language: "en",
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

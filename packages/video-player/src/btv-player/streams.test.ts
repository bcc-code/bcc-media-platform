import { describe, expect, it } from "vitest"
import { toVideoLanguageOptions, type StreamLike } from "./streams"

const stream = (
    type: StreamLike["type"],
    videoLanguage: string | null,
    url = `${type}-${videoLanguage ?? "orig"}`
): StreamLike => ({ url, type, videoLanguage })

describe("toVideoLanguageOptions", () => {
    it("keeps one entry per language, the original first and the rest by name", () => {
        expect(
            toVideoLanguageOptions([
                stream("hls_cmaf", "nor"),
                stream("hls_ts", "nor"),
                stream("hls_cmaf", null),
                stream("hls_cmaf", "deu"),
            ])
        ).toEqual([
            { language: null, src: "hls_cmaf-orig" },
            { language: "deu", src: "hls_cmaf-deu" },
            { language: "nor", src: "hls_cmaf-nor" },
        ])
    })

    it("orders the same however the API shuffles the streams", () => {
        const order = (streams: StreamLike[]) =>
            toVideoLanguageOptions(streams).map((o) => o.language)
        const streams = [
            stream("hls_cmaf", null),
            stream("hls_cmaf", "fr"),
            stream("hls_cmaf", "da"),
            stream("hls_cmaf", "nl"),
        ]
        expect(order(streams)).toEqual([null, "da", "fr", "nl"])
        expect(order([...streams].reverse())).toEqual([null, "da", "fr", "nl"])
    })

    it("prefers hls_cmaf over hls_ts however they are ordered", () => {
        expect(
            toVideoLanguageOptions([
                stream("hls_ts", "nor"),
                stream("hls_cmaf", "nor"),
            ])
        ).toEqual([{ language: "nor", src: "hls_cmaf-nor" }])
    })

    it("falls back to hls_ts when a language has no CMAF stream", () => {
        expect(
            toVideoLanguageOptions([
                stream("hls_cmaf", null),
                stream("hls_ts", "nor"),
            ])
        ).toEqual([
            { language: null, src: "hls_cmaf-orig" },
            { language: "nor", src: "hls_ts-nor" },
        ])
    })

    it("drops dash-only languages — <hlsjs-video> can't play an .mpd", () => {
        expect(
            toVideoLanguageOptions([
                stream("hls_cmaf", null),
                stream("dash", "nor"),
            ])
        ).toEqual([{ language: null, src: "hls_cmaf-orig" }])
    })

    it("normalizes codes and treats a blank one as the original", () => {
        expect(
            toVideoLanguageOptions([
                stream("hls_cmaf", "", "a"),
                stream("hls_cmaf", "NOR", "b"),
            ])
        ).toEqual([
            { language: null, src: "a" },
            { language: "nor", src: "b" },
        ])
    })

    it("returns nothing for an empty stream list", () => {
        expect(toVideoLanguageOptions([])).toEqual([])
    })
})

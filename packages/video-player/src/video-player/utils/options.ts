// Split from ../index.ts so tests don't pull custom-element registrations
// into the node environment.

import type { Options } from "../index"

// HlsJsMedia compares `source.type` by strict equality against these exact
// strings; a mismatch drops playback onto the native delegate. Unknown types
// return undefined so the element infers from the URL instead.
const CONTENT_TYPE_M3U8 = "application/vnd.apple.mpegurl"
const CONTENT_TYPE_MP4 = "video/mp4"

export function normalizeSourceType(type?: string): string | undefined {
    switch (type?.trim().toLowerCase()) {
        case "application/x-mpegurl":
        case "application/vnd.apple.mpegurl":
        case "vnd.apple.mpegurl":
            return CONTENT_TYPE_M3U8
        case "video/mp4":
            return CONTENT_TYPE_MP4
        default:
            return undefined
    }
}

export function getDefaults(): Options {
    return {
        src: { type: "application/x-mpegURL" },
        autoplay: false,
        languagePreferenceDefaults: {},
        subtitles: [],
        language: "en",
        videojs: {
            crossOrigin: "anonymous",
        },
    }
}

export function mergeOptions(
    base: Options,
    override: Partial<Options>
): Options {
    return {
        ...base,
        ...override,
        src: { ...base.src, ...(override.src ?? {}) },
        languagePreferenceDefaults: {
            ...base.languagePreferenceDefaults,
            ...(override.languagePreferenceDefaults ?? {}),
        },
        videojs: { ...base.videojs, ...(override.videojs ?? {}) },
    }
}

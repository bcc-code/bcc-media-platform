// Pure option helpers, lifted out of ../index.ts so tests don't pull the
// custom-element side-effect imports (@videojs/html, hls-video, picker
// elements) into the node test environment. The `Options` type lives in
// index.ts and is imported via `import type` (erased at runtime).

import type { Options } from "../index"

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

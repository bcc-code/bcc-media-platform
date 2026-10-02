import type { VideoLanguageOption } from "../video-player"
import {
    canonicalVideoLanguage,
    normalizeVideoLanguage,
    videoLanguageLabel,
} from "../video-player/utils/video-language"

export interface StreamLike {
    url: string
    type: "hls_cmaf" | "dash" | "hls_ts"
    videoLanguage?: string | null
}

// Same order of preference as the Flutter player's getBestStream. `dash` is
// left out entirely: the player builds an <hlsjs-video>, which can't play an
// .mpd, so a DASH-only language is not one we can offer.
const PREFERRED_TYPES: readonly StreamLike["type"][] = ["hls_cmaf", "hls_ts"]

// One entry per distinct videoLanguage, the original first and the rest by
// name. The API's own order can't be used: episode.streams builds the
// translated entries by ranging a Go map, so it comes back shuffled and the
// menu would reorder itself on every load.
export function toVideoLanguageOptions(
    streams: readonly StreamLike[]
): VideoLanguageOption[] {
    const best = new Map<
        string | null,
        { option: VideoLanguageOption; rank: number }
    >()

    for (const stream of streams) {
        const rank = PREFERRED_TYPES.indexOf(stream.type)
        if (rank < 0 || !stream.url) continue

        const language = normalizeVideoLanguage(stream.videoLanguage)
        const key = canonicalVideoLanguage(language)
        const current = best.get(key)
        if (current && current.rank <= rank) continue
        best.set(key, { option: { language, src: stream.url }, rank })
    }

    const options = [...best.values()].map((entry) => entry.option)
    // Native names, so the order holds whatever the UI language is. "Original"
    // is UI text, but it sorts first by rule rather than by name anyway.
    return options.sort((a, b) => {
        if (!a.language) return -1
        if (!b.language) return 1
        return videoLanguageLabel(a, "en").localeCompare(
            videoLanguageLabel(b, "en")
        )
    })
}

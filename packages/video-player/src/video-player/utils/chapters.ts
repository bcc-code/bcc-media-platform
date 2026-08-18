export interface Chapter {
    /** Seconds from the start of the episode. */
    start: number
    /** Seconds. */
    duration: number
    title: string
    /** Still used as the scrub preview for this chapter's range. */
    image?: string | null
}

function timestamp(seconds: number): string {
    const clamped = Math.max(0, seconds)
    const h = Math.floor(clamped / 3600)
    const m = Math.floor((clamped % 3600) / 60)
    const s = clamped % 60
    return `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}:${s
        .toFixed(3)
        .padStart(6, "0")}`
}

function cues(chapters: Chapter[], text: (c: Chapter) => string): string {
    const body = chapters
        .filter((c) => c.duration > 0 && text(c))
        .map(
            (c) =>
                `${timestamp(c.start)} --> ${timestamp(c.start + c.duration)}\n${text(c)}`
        )
    return body.length ? `WEBVTT\n\n${body.join("\n\n")}\n` : ""
}

/** WebVTT chapter markers, or "" when there's nothing to render. */
export function toChaptersVTT(chapters: Chapter[]): string {
    return cues(chapters, (c) => c.title.replace(/\r?\n/g, " ").trim())
}

/**
 * WebVTT thumbnail track built from the per-chapter stills. Coarser than a
 * storyboard sprite — one image per chapter rather than per interval — but the
 * backend exposes no sprite. Cue text is a plain URL, which core reads as a
 * media fragment without coordinates.
 */
export function toThumbnailsVTT(chapters: Chapter[]): string {
    return cues(chapters, (c) => c.image?.trim() ?? "")
}

// Structural views of the standard rendition / track lists v10 exposes on the
// media element, declared locally because @videojs/media is a transitive dep
// and isn't resolvable from this package.

export type VideoRendition = {
    readonly height?: number
    readonly width?: number
    readonly bitrate?: number
    selected: boolean
    active?: boolean
}

export type AudioTrack = {
    id?: string
    readonly label: string
    readonly language: string
    enabled: boolean
}

type ListLike<T> = {
    readonly length: number
    [Symbol.iterator](): Iterator<T>
    addEventListener(
        type: string,
        listener: () => void,
        options?: { signal?: AbortSignal }
    ): void
}

export type VideoRenditionList = ListLike<VideoRendition> & {
    /** -1 means no rendition is pinned, i.e. ABR picks. */
    selectedIndex: number
}
export type AudioTrackList = ListLike<AudioTrack>

export type TrackHost = HTMLElement & {
    videoRenditions?: VideoRenditionList
    audioTracks?: AudioTrackList
}

export function findTrackHost(el: Element): TrackHost | null {
    const player = el.closest("video-player")
    return (player?.querySelector("hlsjs-video") as TrackHost | null) ?? null
}

/**
 * Invoke `attach` once the media element is reachable and again on every
 * `loadstart`. The lists are rebuilt with the playback engine, so a new source
 * means a new list object — `attach` must tolerate being called repeatedly.
 */
export function onTrackHostLoad(
    el: Element,
    signal: AbortSignal,
    attach: () => void
): void {
    queueMicrotask(() => {
        if (signal.aborted) return
        findTrackHost(el)?.addEventListener("loadstart", attach, { signal })
        attach()
    })
}

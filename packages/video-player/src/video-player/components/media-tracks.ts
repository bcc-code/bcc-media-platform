// Structural views of the standard rendition / track lists v10 exposes on the
// media element, declared locally because @videojs/media is a transitive dep
// and isn't resolvable from this package. Used by the public track/quality
// helpers in ../index.ts; the UI reads the same data from the player store.

export type VideoRendition = {
    readonly height?: number
    selected: boolean
}

export type AudioTrack = {
    readonly label: string
    readonly language: string
    enabled: boolean
}

type ListLike<T> = {
    readonly length: number
    [Symbol.iterator](): Iterator<T>
}

export type TrackHost = HTMLElement & {
    videoRenditions?: ListLike<VideoRendition> & {
        /** -1 means no rendition is pinned, i.e. ABR picks. */
        selectedIndex: number
    }
    audioTracks?: ListLike<AudioTrack>
}

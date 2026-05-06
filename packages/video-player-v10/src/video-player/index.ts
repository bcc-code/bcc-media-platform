// Side-effect imports register the v10 custom elements; we ship our own
// ejected skin (see ./skin) instead of @videojs/html/video/skin.
import "@videojs/html/video/ui"
import "@videojs/html/media/hls-video"
import "./components/subtitle-picker"
import "./components/audio-picker"
import "./skin/skin.css"

import { buildSkin } from "./skin/skin"
import { enableNPAW, type NPAWOptions, setOptions } from "./npaw"

export interface Options {
    src: {
        type?: "application/x-mpegURL" | string
        src?: string
    }
    languagePreferenceDefaults: {
        audio?: string
        subtitles?: string
    }
    npaw?: NPAWOptions
    autoplay: boolean
    subtitles: any[]
    videojs: {
        poster?: string
        crossOrigin?: string
        // v8 legacy options accepted but ignored under v10:
        [key: string]: unknown
    }
    onProgress?: (currentTime: number, duration: number, player: Player) => void
}

export interface TrackOption {
    language: string
    label: string
}

export interface Player {
    readonly element: HTMLElement
    readonly mediaEl: HTMLVideoElement
    getAudioLanguages(): TrackOption[]
    getSubtitleLanguages(): TrackOption[]
    setAudioTrackToLanguage(language?: string): void
    setSubtitleTrackToLanguage(language?: string): void
    setVideoQuality(height: number): void
    dispose(): void
}

export async function createPlayer(
    containerId: string,
    opts: Partial<Options>
): Promise<Player> {
    const container = document.getElementById(containerId)
    if (!container) {
        throw new Error(`createPlayer: #${containerId} not found`)
    }

    const options = mergeOptions(getDefaults(), opts)

    // Tear down any existing player rendered into this container.
    container.querySelector("video-player")?.remove()

    const player = document.createElement("video-player")
    const media = document.createElement("hls-video") as HTMLElement & {
        src: string
    }

    if (options.src.src) {
        media.src = options.src.src
    }
    if (options.autoplay) {
        media.setAttribute("autoplay", "")
    }
    if (options.videojs.crossOrigin) {
        media.setAttribute("crossorigin", String(options.videojs.crossOrigin))
    }
    media.setAttribute("playsinline", "")

    const skin = buildSkin(media, { poster: options.videojs.poster })
    player.appendChild(skin)
    container.insertAdjacentElement("afterbegin", player)

    // Subtitles passed in as `<track>` descriptors get appended to the media
    // element. v10 picks them up via the standard text-track API.
    for (const track of options.subtitles ?? []) {
        const el = document.createElement("track")
        if (track.src) el.src = track.src
        if (track.srclang) el.srclang = track.srclang
        if (track.label) el.label = track.label
        el.kind = track.kind ?? "subtitles"
        if (track.default) el.default = true
        media.appendChild(el)
    }

    if (options.onProgress) {
        const onProgress = options.onProgress
        media.addEventListener("timeupdate", () => {
            const m = media as unknown as HTMLVideoElement
            const currentTime = m.currentTime
            const duration = m.duration
            if (currentTime && duration) onProgress(currentTime, duration, api)
        })
    }

    const mediaEl = media as unknown as HTMLVideoElement
    const api: Player = {
        element: player,
        mediaEl,
        getAudioLanguages() {
            return getAudioLanguages(media)
        },
        getSubtitleLanguages() {
            return getSubtitleLanguages(mediaEl)
        },
        setAudioTrackToLanguage(language) {
            setAudioTrackToLanguage(media, language)
        },
        setSubtitleTrackToLanguage(language) {
            setSubtitleTrackToLanguage(mediaEl, language)
        },
        setVideoQuality(_height) {
            // TODO(v10): wire to core quality-levels feature once selector lands.
            // See V10_MIGRATION.md row #5 / #8.
        },
        dispose() {
            player.remove()
        },
    }

    if (
        options.languagePreferenceDefaults.audio ||
        options.languagePreferenceDefaults.subtitles
    ) {
        media.addEventListener(
            "loadedmetadata",
            () => {
                api.setAudioTrackToLanguage(
                    options.languagePreferenceDefaults.audio
                )
                api.setSubtitleTrackToLanguage(
                    options.languagePreferenceDefaults.subtitles
                )
            },
            { once: true }
        )
    }

    if (options.npaw?.enabled === true) {
        enableNPAW(api, options.npaw)
    }

    return api
}

export function setNPAWOptions(player: Player, options: NPAWOptions): void {
    setOptions(player, options)
}

// hls.js (when active) owns the audio-track list via its engine, not via the
// HTMLMediaElement.audioTracks API (which Chrome/Firefox don't populate for
// MSE playback). Native HLS (Safari) uses the HTMLMediaElement API. Handle both.
type HlsAudioTrack = { id: number; lang?: string; name?: string }
type HlsEngine = {
    audioTracks: HlsAudioTrack[]
    audioTrack: number
}
type NativeAudioTrack = { language?: string; label?: string; enabled: boolean }
type NativeAudioTrackList = { length: number; [i: number]: NativeAudioTrack }
function hlsEngine(media: HTMLElement): HlsEngine | null {
    return (media as { engine?: HlsEngine | null }).engine ?? null
}

function getAudioLanguages(media: HTMLElement): TrackOption[] {
    const engine = hlsEngine(media)
    if (engine?.audioTracks?.length) {
        return engine.audioTracks.map((t) => ({
            language: t.lang ?? "",
            label: t.name ?? t.lang ?? "",
        }))
    }
    const native = (media as unknown as { audioTracks?: NativeAudioTrackList })
        .audioTracks
    if (!native) return []
    const out: TrackOption[] = []
    for (let i = 0; i < native.length; i++) {
        const t = native[i]
        out.push({ language: t.language ?? "", label: t.label ?? t.language ?? "" })
    }
    return out
}

function setAudioTrackToLanguage(media: HTMLElement, language?: string) {
    if (!language) return
    const engine = hlsEngine(media)
    if (engine?.audioTracks?.length) {
        const idx = engine.audioTracks.findIndex((t) => t.lang === language)
        if (idx >= 0) engine.audioTrack = engine.audioTracks[idx].id
        return
    }
    const native = (media as unknown as { audioTracks?: NativeAudioTrackList })
        .audioTracks
    if (!native) return
    for (let i = 0; i < native.length; i++) {
        const t = native[i]
        if (t.language === language) t.enabled = true
    }
}

function getSubtitleLanguages(media: HTMLVideoElement): TrackOption[] {
    return Array.from(media.textTracks)
        .filter((t) => t.kind === "captions" || t.kind === "subtitles")
        .map((t) => ({
            language: t.language ?? "",
            label: t.label ?? t.language ?? "",
        }))
}

function setSubtitleTrackToLanguage(media: HTMLVideoElement, language?: string) {
    const tracks = Array.from(media.textTracks).filter(
        (t) => t.kind === "captions" || t.kind === "subtitles"
    )
    const target = language
        ? tracks.find((t) => t.language?.substring(0, 3) === language)
        : undefined
    for (const t of tracks) {
        t.mode = target && target.id === t.id ? "showing" : "disabled"
    }
}

function getDefaults(): Options {
    return {
        src: { type: "application/x-mpegURL" },
        autoplay: false,
        languagePreferenceDefaults: {},
        subtitles: [],
        videojs: {
            crossOrigin: "anonymous",
        },
    }
}

function mergeOptions(base: Options, override: Partial<Options>): Options {
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

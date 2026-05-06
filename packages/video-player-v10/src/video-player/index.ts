// Side-effect imports register the v10 custom elements; we ship our own
// ejected skin (see ./skin) instead of @videojs/html/video/skin.
import "@videojs/html/video/ui"
import "@videojs/html/media/hls-video"
import "./components/subtitle-picker"
import "./components/audio-picker"
import "./components/quality-picker"
import "./components/playback-rate-picker"
import "./components/live-button"
import "./components/dismiss-controls-button"
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
    /** Switches the player to a live-aware skin (LIVE badge, no time
     *  displays / seek buttons / thumbnail preview). Defaults to false. */
    live?: boolean
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
        config: Record<string, unknown>
    }

    // hls.js config — set before `src` so the engine picks it up on init.
    // capLevelToPlayerSize is the v10 equivalent of v8's
    // limitRenditionByPlayerDimensions (don't pull a 1080p rendition into a
    // 320x240 viewport). preferPlayback="mse" — v8's overrideNative — is
    // already the default in @videojs/html, so no need to set it explicitly.
    // abrEwmaDefaultEstimate seeds the ABR algorithm with the bandwidth we
    // measured last session — replicates v8's `useBandwidthFromLocalStorage`.
    const savedBandwidth = readSavedBandwidth()
    media.config = {
        capLevelToPlayerSize: true,
        ...(savedBandwidth != null
            ? { abrEwmaDefaultEstimate: savedBandwidth }
            : {}),
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

    const skin = buildSkin(media, {
        poster: options.videojs.poster,
        live: options.live,
    })
    player.appendChild(skin)
    container.insertAdjacentElement("afterbegin", player)

    const teardown = new AbortController()
    setupErrorHandling(media, skin, teardown.signal)
    setupBandwidthPersistence(media, teardown.signal)

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
        setVideoQuality(height) {
            setVideoQuality(media, height)
        },
        dispose() {
            teardown.abort()
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
        enableNPAW(api, options.npaw, teardown.signal)
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
        out.push({
            language: t.language ?? "",
            label: t.label ?? t.language ?? "",
        })
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

// Persist the current ABR bandwidth estimate to localStorage so the next
// session starts with a sensible bitrate guess instead of hls.js's 500 kbps
// default. Replicates v8's `useBandwidthFromLocalStorage`. Reads happen in
// createPlayer() (before `src` is set so hls.js seeds the EWMA on init);
// writes are throttled to once every 10s so we don't hammer localStorage.
const BW_STORAGE_KEY = "bccm-video-player.bandwidth-estimate"
const BW_WRITE_THROTTLE_MS = 10_000

function readSavedBandwidth(): number | null {
    try {
        const raw = localStorage.getItem(BW_STORAGE_KEY)
        if (!raw) return null
        const value = Number(raw)
        return Number.isFinite(value) && value > 0 ? value : null
    } catch {
        // localStorage unavailable (private mode, blocked, SSR).
        return null
    }
}

function writeSavedBandwidth(value: number): void {
    if (!Number.isFinite(value) || value <= 0) return
    try {
        localStorage.setItem(BW_STORAGE_KEY, String(Math.round(value)))
    } catch {
        // ignore — best-effort persistence
    }
}

type BandwidthEngine = {
    bandwidthEstimate: number
    on(event: string, cb: () => void): void
    off(event: string, cb: () => void): void
}

function setupBandwidthPersistence(
    media: HTMLElement,
    signal: AbortSignal
): void {
    let lastWritten = 0
    let pollHandle: ReturnType<typeof setInterval> | null = null
    let attached: BandwidthEngine | null = null

    const onFragLoaded = () => {
        const now = Date.now()
        if (now - lastWritten < BW_WRITE_THROTTLE_MS) return
        if (!attached) return
        writeSavedBandwidth(attached.bandwidthEstimate)
        lastWritten = now
    }

    const tryAttach = () => {
        const engine = (media as { engine?: BandwidthEngine | null }).engine
        if (!engine) return false
        attached = engine
        engine.on("hlsFragLoaded", onFragLoaded)
        if (pollHandle) clearInterval(pollHandle)
        pollHandle = null
        return true
    }

    if (!tryAttach()) {
        pollHandle = setInterval(tryAttach, 250)
    }

    signal.addEventListener("abort", () => {
        if (pollHandle) clearInterval(pollHandle)
        pollHandle = null
        if (attached) {
            // Final flush so the most recent estimate is persisted.
            writeSavedBandwidth(attached.bandwidthEstimate)
            attached.off("hlsFragLoaded", onFragLoaded)
            attached = null
        }
    })
}

// Listen for fatal HLS errors dispatched by v10's HlsJsMediaErrorsMixin and
// populate the error dialog text. v10's <media-error-dialog> auto-opens when
// the store error state is non-null, but the title / description elements
// don't write their own text — we own the contents. For 401/403 responses
// (BTV's auth tokens expiring during playback) surface a session-expired
// message that points the user at reloading.
function setupErrorHandling(
    media: HTMLElement,
    skin: HTMLElement,
    signal: AbortSignal
): void {
    media.addEventListener(
        "error",
        (e) => {
            const error = (e as ErrorEvent).error as
                | {
                      message?: string
                      data?: { response?: { code?: number } }
                  }
                | undefined
            const code = error?.data?.response?.code
            const titleEl = skin.querySelector<HTMLElement>(
                "media-alert-dialog-title"
            )
            const descEl = skin.querySelector<HTMLElement>(
                "media-alert-dialog-description"
            )
            if (!titleEl || !descEl) return

            if (code === 401 || code === 403) {
                titleEl.textContent = "Session expired"
                descEl.textContent =
                    "Try reloading the page to continue watching."
            } else {
                titleEl.textContent = "Something went wrong."
                descEl.textContent = error?.message ?? ""
            }
        },
        { signal }
    )
}

function setVideoQuality(media: HTMLElement, height: number): void {
    const engine = (
        media as {
            engine?: { levels: { height?: number }[]; currentLevel: number }
        }
    ).engine
    if (!engine?.levels?.length) return
    if (!height || height < 0) {
        engine.currentLevel = -1 // re-enable ABR (Auto)
        return
    }
    const idx = engine.levels.findIndex((l) => l.height === height)
    if (idx >= 0) engine.currentLevel = idx
}

function setSubtitleTrackToLanguage(
    media: HTMLVideoElement,
    language?: string
) {
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

// Side-effect imports register the v10 custom elements; we ship our own
// ejected skin (see ./skin) instead of @videojs/html/video/skin.
import "@videojs/html/video/ui"
import "@videojs/html/media/hlsjs-video"
import "@videojs/html/media/google-cast"
import "./components/subtitle-picker"
import "./components/audio-picker"
import "./components/quality-picker"
import "./components/playback-rate-picker"
import "./components/live-button"
import "./components/dismiss-controls-button"
import "./skin/skin.css"

import { buildSkin } from "./skin/skin"
import { enableNPAW, type NPAWOptions, restartView, setOptions } from "./npaw"
import { getDefaults, mergeOptions, normalizeSourceType } from "./utils/options"
import {
    BW_WRITE_THROTTLE_MS,
    readSavedBandwidth,
    writeSavedBandwidth,
} from "./utils/bandwidth"
import {
    DEFAULT_LANG,
    getLanguage,
    isSupportedLang,
    LANGUAGE_CHANGE_EVENT,
    type Lang,
    relabelSkin,
    t,
} from "./i18n/strings"
import { relabelButtons } from "./i18n/button-labels"
import type { AudioTrack, TrackHost } from "./components/media-tracks"

export {
    DEFAULT_LANG,
    getLanguageName,
    getTrackLanguageName,
    isSupportedLang,
    LANGUAGE_CHANGE_EVENT,
    SUPPORTED_LANGS,
} from "./i18n/strings"
export type { Lang } from "./i18n/strings"

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
    /** UI language for tooltips, pickers, and error messages. Defaults
     *  to `"en"`. Use `player.setLanguage(...)` to swap at runtime. */
    language?: Lang
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
    /** Swap the UI language (tooltips, pickers, error dialog) at runtime.
     *  Falls back to `"en"` for unsupported values. */
    setLanguage(lang: Lang): void
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
    const initialLang: Lang = isSupportedLang(options.language)
        ? options.language
        : DEFAULT_LANG

    // Tear down any existing player rendered into this container.
    container.querySelector("video-player")?.remove()

    const player = document.createElement("video-player")
    player.setAttribute("data-lang", initialLang)
    const media = document.createElement("hlsjs-video")

    // Engine options are read when the engine is constructed, so they go in
    // with `src` as one assignment. preferPlayback already defaults to "mse".
    const savedBandwidth = readSavedBandwidth()
    const sourceType = normalizeSourceType(options.src.type)
    media.source = {
        ...(options.src.src ? { src: options.src.src } : {}),
        ...(sourceType ? { type: sourceType } : {}),
        engine: {
            hlsJs: {
                capLevelToPlayerSize: true,
                ...(savedBandwidth != null
                    ? { abrEwmaDefaultEstimate: savedBandwidth }
                    : {}),
            },
        },
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
        language: initialLang,
    })
    player.appendChild(skin)
    // Cast is a declared component since beta.26 — <media-cast-button> alone
    // has nothing behind it. No `receiver`, so it uses the default receiver.
    player.appendChild(document.createElement("google-cast"))
    container.insertAdjacentElement("afterbegin", player)

    const teardown = new AbortController()
    setupErrorHandling(media, skin, teardown.signal)
    setupBandwidthPersistence(media, teardown.signal)

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
        setLanguage(lang) {
            const next: Lang = isSupportedLang(lang) ? lang : DEFAULT_LANG
            if (player.getAttribute("data-lang") === next) return
            player.setAttribute("data-lang", next)
            relabelSkin(skin, next)
            relabelButtons(skin)
            renderErrorDialog(skin, next)
            player.dispatchEvent(
                new CustomEvent(LANGUAGE_CHANGE_EVENT, {
                    bubbles: false,
                    detail: { language: next },
                })
            )
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

// For live streams rolling over to a new program — unlike setNPAWOptions,
// which updates the ongoing view in place.
export function restartNPAWView(player: Player, options: NPAWOptions): void {
    restartView(player, options)
}

function audioTracks(media: HTMLElement): AudioTrack[] {
    const list = (media as TrackHost).audioTracks
    return list ? [...list] : []
}

function getAudioLanguages(media: HTMLElement): TrackOption[] {
    return audioTracks(media).map((track) => ({
        language: track.language,
        label: track.label || track.language,
    }))
}

function setAudioTrackToLanguage(media: HTMLElement, language?: string) {
    if (!language) return
    const target = audioTracks(media).find((t) => t.language === language)
    if (target) target.enabled = true
}

function getSubtitleLanguages(media: HTMLVideoElement): TrackOption[] {
    return Array.from(media.textTracks)
        .filter((t) => t.kind === "captions" || t.kind === "subtitles")
        .map((t) => ({
            language: t.language ?? "",
            label: t.label ?? t.language ?? "",
        }))
}

// Persist the ABR estimate so the next session starts with a real bitrate
// guess rather than hls.js's 500 kbps default. Writes are throttled.

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

// <media-error-dialog> auto-opens on error but never writes its own title or
// description, so we own that text. The last code/message is stashed on the
// skin element so setLanguage() can re-translate whatever is on screen.
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
            skin.dataset.bccmErrorCode = code != null ? String(code) : ""
            skin.dataset.bccmErrorMessage = error?.message ?? ""
            renderErrorDialog(skin, getLanguage(skin))
        },
        { signal }
    )
}

function renderErrorDialog(skin: HTMLElement, lang: Lang): void {
    const codeStr = skin.dataset.bccmErrorCode
    if (codeStr == null || codeStr === "") return
    const titleEl = skin.querySelector<HTMLElement>("media-alert-dialog-title")
    const descEl = skin.querySelector<HTMLElement>(
        "media-alert-dialog-description"
    )
    if (!titleEl || !descEl) return
    const code = Number(codeStr)
    if (code === 401 || code === 403) {
        titleEl.textContent = t(lang, "sessionExpired")
        descEl.textContent = t(lang, "sessionExpiredDesc")
    } else {
        titleEl.textContent = t(lang, "somethingWentWrong")
        descEl.textContent = skin.dataset.bccmErrorMessage ?? ""
    }
}

function setVideoQuality(media: HTMLElement, height: number): void {
    const list = (media as TrackHost).videoRenditions
    if (!list?.length) return
    if (!height || height < 0) {
        list.selectedIndex = -1 // back to ABR
        return
    }
    const idx = [...list].findIndex((r) => r.height === height)
    if (idx >= 0) list.selectedIndex = idx
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

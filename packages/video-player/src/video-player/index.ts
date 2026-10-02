// Side-effect imports register the v10 custom elements; we ship our own
// ejected skin (see ./skin) instead of @videojs/html/video/skin.
import "@videojs/html/video/ui"
import "@videojs/html/media/hlsjs-video"
import "@videojs/html/media/google-cast"
import "./components/settings-trigger"
import "./components/live-button"
import "./components/dismiss-controls-button"
import "./skin/skin.css"

import { buildSkin, renderVideoLanguageMenu } from "./skin/skin"
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
import { registerCoreTranslations, toCoreLocale } from "./i18n/core-i18n"
import { type Chapter, toChaptersVTT, toThumbnailsVTT } from "./utils/chapters"
import {
    dedupeVideoLanguages,
    findVideoLanguageOption,
    normalizeVideoLanguage,
    type VideoLanguageOption,
    videoLanguageFromValue,
} from "./utils/video-language"

export {
    DEFAULT_LANG,
    getLanguageName,
    getTrackLanguageName,
    isSupportedLang,
    LANGUAGE_CHANGE_EVENT,
    SUPPORTED_LANGS,
} from "./i18n/strings"
export type { Lang } from "./i18n/strings"
export type { VideoLanguageOption } from "./utils/video-language"

/** Fired on the player element after the video language changes.
 *  `detail.language` is the new code, or `null` for the original. */
export const VIDEO_LANGUAGE_CHANGE_EVENT = "bccm-videolanguagechange"

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
    /** Chapter markers for the time slider; their stills double as the scrub
     *  preview. */
    chapters?: Chapter[]
    /** UI language for tooltips, pickers, and error messages. Defaults
     *  to `"en"`. Use `player.setLanguage(...)` to swap at runtime. */
    language?: Lang
    /** Alternate renditions that differ in the picture itself — burned-in
     *  translated text, or a sign-language version. Each is its own manifest,
     *  so switching swaps the source rather than selecting a track.
     *  `language: null` is the original. A picker appears in the settings menu
     *  once there are two or more; the selected entry's `src` wins over
     *  `src.src`. */
    videoLanguages?: VideoLanguageOption[]
    /** Which of `videoLanguages` to start on. Unknown or absent falls back to
     *  the first entry. */
    videoLanguage?: string | null
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
    getVideoLanguages(): VideoLanguageOption[]
    /** The code of the video language on screen, `null` for the original. */
    getVideoLanguage(): string | null
    /** Swap the video rendition, keeping the playback position, the play/pause
     *  state, and the selected audio and subtitle languages. Unknown codes are
     *  ignored. */
    setVideoLanguage(language: string | null): void
    /** Swap the UI language (tooltips, pickers, error dialog) at runtime.
     *  Falls back to `"en"` for unsupported values. */
    setLanguage(lang: Lang): void
    dispose(): void
}

const PLAYBACK_RATES = [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2]

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

    registerCoreTranslations()

    // Tear down any existing player rendered into this container.
    container.querySelector("video-player")?.remove()

    const player = document.createElement("video-player")
    player.setAttribute("data-lang", initialLang)
    const media = document.createElement("hlsjs-video")

    // The picked rendition supplies the source; `src.src` is the fallback for
    // callers that have a single stream and no language list. An unknown
    // request falls back to the first entry rather than failing to play.
    const videoLanguages = dedupeVideoLanguages(options.videoLanguages ?? [])
    const initialVideoLanguage =
        findVideoLanguageOption(videoLanguages, options.videoLanguage) ??
        videoLanguages[0]
    let currentVideoLanguage = initialVideoLanguage?.language ?? null
    const initialSrc = initialVideoLanguage?.src ?? options.src.src

    // Engine options are read when the engine is constructed, so they go in
    // with `src` as one assignment. preferPlayback already defaults to "mse".
    const savedBandwidth = readSavedBandwidth()
    const sourceType = normalizeSourceType(options.src.type)
    media.source = {
        ...(initialSrc ? { src: initialSrc } : {}),
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
        videoLanguages,
        videoLanguage: currentVideoLanguage,
    })
    // Core's UI text comes from the i18n context, so the provider has to be an
    // ancestor of the skin — it isn't baked into <video-player>.
    const i18n = document.createElement("media-i18n")
    i18n.lang = toCoreLocale(initialLang)
    i18n.appendChild(skin)
    player.appendChild(i18n)
    // Cast is a declared component since beta.26 — <media-cast-button> alone
    // has nothing behind it. No `receiver`, so it uses the default receiver.
    player.appendChild(document.createElement("google-cast"))
    container.insertAdjacentElement("afterbegin", player)

    // Core's defaults include odd 0.2 / 0.7 stops. The list lives in the
    // player store; there is no prop for it.
    playerStore(player)?.$state?.patch({ playbackRates: PLAYBACK_RATES })

    const teardown = new AbortController()
    setupErrorHandling(media, skin, teardown.signal)
    setupBandwidthPersistence(media, teardown.signal)

    attachVttTrack(media, "chapters", toChaptersVTT(options.chapters ?? []))
    attachVttTrack(
        media,
        "metadata",
        toThumbnailsVTT(options.chapters ?? []),
        "thumbnails"
    )

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
            return getAudioLanguages(player)
        },
        getSubtitleLanguages() {
            return getSubtitleLanguages(mediaEl)
        },
        setAudioTrackToLanguage(language) {
            setAudioTrackToLanguage(player, language)
        },
        setSubtitleTrackToLanguage(language) {
            setSubtitleTrackToLanguage(mediaEl, language)
        },
        setVideoQuality(height) {
            setVideoQuality(player, height)
        },
        getVideoLanguages() {
            return videoLanguages.map((option) => ({ ...option }))
        },
        getVideoLanguage() {
            return currentVideoLanguage
        },
        setVideoLanguage(language) {
            switchVideoLanguage(language)
        },
        setLanguage(lang) {
            const next: Lang = isSupportedLang(lang) ? lang : DEFAULT_LANG
            if (player.getAttribute("data-lang") === next) return
            player.setAttribute("data-lang", next)
            i18n.lang = toCoreLocale(next)
            relabelSkin(skin, next)
            renderVideoLanguageMenu(
                skin,
                videoLanguages,
                currentVideoLanguage,
                next
            )
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

    // Swapping the manifest reloads the picture but nothing else should move:
    // the position, the play/pause state, and whichever audio and subtitle
    // languages the viewer is on all carry over to the new tracks.
    function switchVideoLanguage(language: string | null): void {
        const option = findVideoLanguageOption(videoLanguages, language)
        if (!option) return
        if (option.language === currentVideoLanguage) return
        currentVideoLanguage = option.language

        const resumeAt = mediaEl.currentTime
        const wasPlaying = !mediaEl.paused && !mediaEl.ended
        const audio = getEnabledAudioLanguage(player)
        const subtitles = getShowingSubtitleLanguage(mediaEl)

        media.addEventListener(
            "loadedmetadata",
            () => {
                if (Number.isFinite(resumeAt) && resumeAt > 0) {
                    mediaEl.currentTime = resumeAt
                }
                setAudioTrackToLanguage(player, audio)
                setSubtitleTrackToLanguage(mediaEl, subtitles)
                if (wasPlaying) void mediaEl.play().catch(() => {})
            },
            { once: true, signal: teardown.signal }
        )

        // Assigning `src` rather than `source` keeps the engine — and with it
        // the ABR estimate and the NPAW adapter registered against it — alive
        // across the swap; hls.js just loads the new manifest.
        ;(media as unknown as { src: string }).src = option.src

        renderVideoLanguageMenu(
            skin,
            videoLanguages,
            currentVideoLanguage,
            getLanguage(skin)
        )
        player.dispatchEvent(
            new CustomEvent(VIDEO_LANGUAGE_CHANGE_EVENT, {
                bubbles: false,
                detail: { language: currentVideoLanguage },
            })
        )
    }

    // `value-change` bubbles out of <media-menu-radio-group>; the group's own
    // value is rewritten by renderVideoLanguageMenu, so a rejected choice
    // snaps back.
    skin.querySelector("[data-bccm-video-languages]")?.addEventListener(
        "value-change",
        (event) => {
            const value = (event as CustomEvent<{ value: string }>).detail
                ?.value
            if (typeof value !== "string") return
            switchVideoLanguage(videoLanguageFromValue(value))
        },
        { signal: teardown.signal }
    )

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

// Reads of the player store, which the skin's controls already drive. Menu
// values are `id || index` — see the quality / audioTrack store features.
type StoreAudioTrack = {
    id?: string
    label: string
    language: string
    enabled?: boolean
}
type StoreRendition = { id?: string; height?: number }
type PlayerStore = {
    $state?: { patch(partial: object): void }
    audioTrackList?: StoreAudioTrack[]
    selectAudioTrack?(value: string): void
    videoRenditionList?: StoreRendition[]
    selectVideoRendition?(value: string): void
}

function playerStore(player: HTMLElement): PlayerStore | null {
    return (player as unknown as { store?: PlayerStore }).store ?? null
}

function optionValue(item: { id?: string }, index: number): string {
    return item.id || String(index)
}

function getAudioLanguages(player: HTMLElement): TrackOption[] {
    const tracks = playerStore(player)?.audioTrackList ?? []
    return tracks.map((track) => ({
        language: track.language,
        label: track.label || track.language,
    }))
}

// What a source swap has to restore: the viewer's current picks, not the
// options' defaults, which only seed the first load.
function getEnabledAudioLanguage(player: HTMLElement): string | undefined {
    const tracks = playerStore(player)?.audioTrackList ?? []
    return tracks.find((track) => track.enabled)?.language || undefined
}

function getShowingSubtitleLanguage(
    media: HTMLVideoElement
): string | undefined {
    return (
        Array.from(media.textTracks).find(
            (t) =>
                (t.kind === "captions" || t.kind === "subtitles") &&
                t.mode === "showing"
        )?.language || undefined
    )
}

function setAudioTrackToLanguage(player: HTMLElement, language?: string) {
    if (!language) return
    const store = playerStore(player)
    const index =
        store?.audioTrackList?.findIndex((t) => t.language === language) ?? -1
    if (index < 0) return
    const track = store!.audioTrackList![index]
    store!.selectAudioTrack?.(optionValue(track, index))
}

// Cues are read off `track.cues`, which stays null while a track is disabled.
// <hlsjs-video> clones light-DOM tracks into its inner <video>, so setting the
// mode here would target the wrong TextTrack — `default` is what makes the
// element switch the clone to `hidden` (see custom-media-element).
function attachVttTrack(
    media: HTMLElement,
    kind: "chapters" | "metadata",
    vtt: string,
    label?: string
): void {
    if (!vtt) return
    const el = document.createElement("track")
    el.kind = kind
    if (label) el.label = label
    el.default = true
    el.src = URL.createObjectURL(new Blob([vtt], { type: "text/vtt" }))
    media.appendChild(el)
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

function setVideoQuality(player: HTMLElement, height: number): void {
    const store = playerStore(player)
    const renditions = store?.videoRenditionList ?? []
    if (!renditions.length) return
    if (!height || height < 0) {
        store?.selectVideoRendition?.("auto")
        return
    }
    const index = renditions.findIndex((r) => r.height === height)
    if (index >= 0) {
        store?.selectVideoRendition?.(optionValue(renditions[index], index))
    }
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

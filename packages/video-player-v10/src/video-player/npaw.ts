import NpawPlugin from "npaw-plugin-nwf"
import * as NpawAdapters from "npaw-plugin-adapters"
import type { Player } from "./index"

export interface NPAWOptions {
    enabled?: boolean
    accountCode?: string
    appName: string
    tracking: {
        isLive?: boolean
        userId?: string
        sessionId?: string
        ageGroup?: string
        metadata: {
            contentId?: string
            title?: string
            episodeTitle?: string
            seasonId?: string
            seasonTitle?: string
            showTitle?: string
            showId?: string
            overrides?: { [key: string]: string }
        }
    }
}

function toConfig(options: NPAWOptions): Record<string, unknown> {
    const md = options.tracking.metadata
    return {
        "content.isLive": options.tracking.isLive === true,
        "content.id": md.contentId, // prefixed by E or P. Episode 385 = E385. Program 52 = P52
        "content.title": md.title,
        "content.program": md.showTitle ?? md.title,
        "content.tvShow": md.showId,
        "content.season": md.seasonId
            ? `${md.seasonId} - ${md.seasonTitle}`
            : undefined,
        "content.episodeTitle": md.episodeTitle,
        obfuscateIp: true,
        "user.name": options.tracking.userId,
        "app.name": options.appName,
        "app.releaseVersion": "",
        "parse.manifest": true,
        "extraparam.1": options.tracking.sessionId,
        "extraparam.2": options.tracking.ageGroup,
        ...md.overrides,
    }
}

// NPAW ships an HlsjsAdapter that consumes the hls.js engine instance
// directly — no custom adapter needed. v10's <hls-video> exposes `.engine`
// once the manifest starts loading; we wait for it before registering.
export function enableNPAW(
    player: Player,
    options: NPAWOptions,
    signal?: AbortSignal
): void {
    if (!options.accountCode) {
        console.warn(
            "NPAW was not enabled because options.npaw.accountCode is invalid."
        )
        return
    }

    const npaw = new NpawPlugin(options.accountCode)
    npaw.setAnalyticsOptions(toConfig(options))
    ;(player as Player & { _npaw?: NpawPlugin })._npaw = npaw

    waitForEngine(player.mediaEl, (engine) => {
        npaw.registerAdapterFromClass(
            engine,
            (NpawAdapters as { HlsjsAdapter: unknown }).HlsjsAdapter
        )
        // VideoJsAdapter (used in v8) reported text-track changes natively.
        // HlsjsAdapter doesn't, so wire equivalent custom events to keep
        // BTV's audio/subtitle engagement metrics intact post-cutover.
        wireTrackChangeEvents(player.mediaEl, engine, npaw, signal)
    })
}

export function setOptions(player: Player, options: NPAWOptions): void {
    const npaw = (player as Player & { _npaw?: NpawPlugin })._npaw
    if (!npaw) return
    npaw.setAnalyticsOptions(toConfig(options))
}

type HlsAudioTrack = { lang?: string; name?: string }
type HlsEngine = {
    audioTracks?: HlsAudioTrack[]
    audioTrack: number
    on(event: string, cb: () => void): void
    off(event: string, cb: () => void): void
}

function wireTrackChangeEvents(
    mediaEl: HTMLElement,
    engine: unknown,
    npaw: NpawPlugin,
    signal: AbortSignal | undefined
): void {
    const adapter = npaw.getAdapter() as
        | { fireEvent(name: string, dimensions?: object): void }
        | undefined
    if (!adapter?.fireEvent) return

    // Subtitles: v10's hls.js promotes subtitle tracks onto media.textTracks,
    // so DOM events cover both native HLS and MSE paths.
    const tracks = (mediaEl as HTMLVideoElement).textTracks
    const onSubChange = () => {
        const active = Array.from(tracks).find(
            (t) =>
                t.mode === "showing" &&
                (t.kind === "subtitles" || t.kind === "captions")
        )
        adapter.fireEvent("subtitleChange", {
            language: active?.language ?? "off",
            label: active?.label ?? "off",
        })
    }
    tracks.addEventListener("change", onSubChange)
    signal?.addEventListener("abort", () =>
        tracks.removeEventListener("change", onSubChange)
    )

    // Audio tracks: hls.js owns the list; subscribe to its switch events.
    const eng = engine as HlsEngine
    if (typeof eng.on === "function") {
        const onAudioChange = () => {
            const active = eng.audioTracks?.[eng.audioTrack]
            adapter.fireEvent("audioChange", {
                language: active?.lang ?? "",
                label: active?.name ?? "",
            })
        }
        eng.on("hlsAudioTrackSwitched", onAudioChange)
        signal?.addEventListener("abort", () =>
            eng.off("hlsAudioTrackSwitched", onAudioChange)
        )
    }
}

// hls.js engine becomes available asynchronously after src is set. Poll
// until present, then invoke. Returns a teardown so callers can cancel
// (currently unused — registration is fire-and-forget for the player's
// lifetime; NPAW handles its own cleanup when the engine is destroyed).
function waitForEngine(
    mediaEl: HTMLElement,
    cb: (engine: unknown) => void
): void {
    const get = () =>
        (mediaEl as { engine?: unknown | null }).engine ?? null
    const initial = get()
    if (initial) {
        cb(initial)
        return
    }
    const id = setInterval(() => {
        const engine = get()
        if (engine) {
            clearInterval(id)
            cb(engine)
        }
    }, 250)
}

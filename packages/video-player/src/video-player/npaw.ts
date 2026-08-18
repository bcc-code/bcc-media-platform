import NpawPlugin from "npaw-plugin-nwf"
import * as NpawAdapters from "npaw-plugin-adapters"
import Hls from "hls.js"
import type { Player } from "./index"
import { toConfig, type NPAWOptions } from "./utils/npaw"

export type { NPAWOptions } from "./utils/npaw"

// HlsjsAdapter uses bare `Hls.Events.X` and expects a runtime global.
;(globalThis as { Hls?: unknown }).Hls = Hls

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

        // checkExistsPlayer walks parentNode from `engine.media`, which stops
        // at <hlsjs-video>'s shadow boundary and reports the player as absent,
        // suppressing every event. The element is on the page, so force it.
        const adapter = npaw.getAdapter() as
            | { checkExistsPlayer?: () => boolean }
            | undefined
        if (adapter) adapter.checkExistsPlayer = () => true

        // HlsjsAdapter doesn't report track changes; VideoJsAdapter did.
        wireTrackChangeEvents(player.mediaEl, engine, npaw, signal)
    })
}

export function setOptions(player: Player, options: NPAWOptions): void {
    const npaw = (player as Player & { _npaw?: NpawPlugin })._npaw
    if (!npaw) return
    npaw.setAnalyticsOptions(toConfig(options))
}

// Splits a continuous live stream into one view per program. removeAdapter
// stops the old view; re-registering on the still-playing engine starts a new
// one. No re-wiring needed — wireTrackChangeEvents resolves the adapter lazily.
export function restartView(player: Player, options: NPAWOptions): void {
    const npaw = (player as Player & { _npaw?: NpawPlugin })._npaw
    if (!npaw) return
    npaw.removeAdapter()
    npaw.setAnalyticsOptions(toConfig(options))

    const engine = (player.mediaEl as { engine?: unknown | null }).engine
    if (!engine) return
    npaw.registerAdapterFromClass(
        engine,
        (NpawAdapters as { HlsjsAdapter: unknown }).HlsjsAdapter
    )
    const adapter = npaw.getAdapter() as
        | { checkExistsPlayer?: () => boolean }
        | undefined
    if (adapter) adapter.checkExistsPlayer = () => true
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
    // Lazily resolved — restartView swaps the adapter out.
    const fire = (name: string, dimensions?: object) => {
        const adapter = npaw.getAdapter() as
            | { fireEvent?(name: string, dimensions?: object): void }
            | undefined
        adapter?.fireEvent?.(name, dimensions)
    }

    // hls.js promotes subtitles onto textTracks, so DOM events cover both
    // the native HLS and MSE paths.
    const tracks = (mediaEl as HTMLVideoElement).textTracks
    const onSubChange = () => {
        const active = Array.from(tracks).find(
            (t) =>
                t.mode === "showing" &&
                (t.kind === "subtitles" || t.kind === "captions")
        )
        fire("subtitleChange", {
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
            fire("audioChange", {
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

// The engine only appears some time after src is set.
function waitForEngine(
    mediaEl: HTMLElement,
    cb: (engine: unknown) => void
): void {
    const get = () => (mediaEl as { engine?: unknown | null }).engine ?? null
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

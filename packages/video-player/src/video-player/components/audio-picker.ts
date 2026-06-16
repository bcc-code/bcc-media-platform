import { MediaElement } from "@videojs/html"
import { wirePickerKeyboard } from "./picker-keyboard"
import { wirePickerPositioning } from "./picker-position"
import {
    getLanguage,
    getTrackLanguageName,
    onLanguageChange,
    t,
} from "../i18n/strings"
import ICON_LANGUAGE from "../skin/icons/language.svg?raw"

const TAG = "bccm-audio-picker"
let popoverIdSeq = 0

type HlsAudioTrack = { id: number; lang?: string; name?: string }
type HlsEngine = {
    audioTracks: HlsAudioTrack[]
    audioTrack: number
    on(event: string, cb: () => void): void
    off(event: string, cb: () => void): void
}
type EngineHost = HTMLElement & { engine?: HlsEngine | null }

// hls.js owns the audio-track list — there is no v10 store feature for it as of
// @videojs/core@10.0.0-beta.23. Subscribe to the engine directly. Native HLS
// (Safari) populates HTMLMediaElement.audioTracks instead; we surface that as
// a fallback so the picker still works there.
export class AudioPickerElement extends MediaElement {
    static readonly tagName = TAG

    #disconnect: AbortController | null = null
    #engineUnsub: (() => void) | null = null
    #button = document.createElement("button")
    #menu = document.createElement("div")
    #pollHandle: ReturnType<typeof setInterval> | null = null

    connectedCallback(): void {
        super.connectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = new AbortController()
        const { signal } = this.#disconnect

        const popoverId = `bccm-aud-${++popoverIdSeq}`
        this.#menu.id = popoverId
        this.#menu.popover = "auto"
        this.#menu.className = "bccm-picker-menu"
        this.#menu.setAttribute("role", "menu")

        this.#button.type = "button"
        this.#button.className =
            "bccm-picker-button media-button media-button--subtle media-button--icon"
        this.#button.setAttribute("popovertarget", popoverId)
        this.#button.setAttribute(
            "aria-label",
            t(getLanguage(this), "audioLanguage")
        )
        this.#button.innerHTML = ICON_LANGUAGE

        wirePickerPositioning(this.#button, this.#menu, signal)
        wirePickerKeyboard(this.#button, this.#menu, signal)

        this.replaceChildren(this.#button, this.#menu)

        onLanguageChange(this, signal, () => this.#refreshFromEngine())

        this.#waitForEngine()
    }

    disconnectedCallback(): void {
        super.disconnectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = null
        this.#engineUnsub?.()
        this.#engineUnsub = null
        if (this.#pollHandle) clearInterval(this.#pollHandle)
        this.#pollHandle = null
    }

    #waitForEngine(): void {
        const tryAttach = () => {
            const media = this.#findMedia()
            const engine = media?.engine
            if (engine) {
                if (this.#pollHandle) clearInterval(this.#pollHandle)
                this.#pollHandle = null
                this.#attachEngine(engine)
                return true
            }
            return false
        }
        if (tryAttach()) return
        this.#pollHandle = setInterval(tryAttach, 250)
    }

    #attachEngine(engine: HlsEngine): void {
        const refresh = () => this.#render(engine)
        engine.on("hlsAudioTracksUpdated", refresh)
        engine.on("hlsAudioTrackSwitched", refresh)
        this.#engineUnsub = () => {
            engine.off("hlsAudioTracksUpdated", refresh)
            engine.off("hlsAudioTrackSwitched", refresh)
        }
        refresh()
    }

    #render(engine: HlsEngine): void {
        const tracks = engine.audioTracks ?? []
        const active = tracks.find((track) => track.id === engine.audioTrack)
        const lang = getLanguage(this)
        const labelFor = (track: HlsAudioTrack) =>
            getTrackLanguageName(track.lang) ||
            track.name ||
            track.lang ||
            t(lang, "audioTrackFallback", { id: track.id })
        this.#button.setAttribute(
            "aria-label",
            active
                ? t(lang, "audioLanguageActive", { name: labelFor(active) })
                : t(lang, "audioLanguage")
        )
        this.toggleAttribute("data-empty", tracks.length <= 1)

        this.#menu.replaceChildren()
        for (const track of tracks) {
            const item = document.createElement("button")
            item.type = "button"
            item.setAttribute("tabindex", "-1")
            item.className = "bccm-picker-item"
            item.setAttribute("role", "menuitemradio")
            item.textContent = labelFor(track)
            if (track.id === engine.audioTrack)
                item.setAttribute("aria-checked", "true")
            item.addEventListener("click", () => {
                engine.audioTrack = track.id
                this.#menu.hidePopover()
            })
            this.#menu.appendChild(item)
        }
    }

    #refreshFromEngine(): void {
        const engine = this.#findMedia()?.engine
        if (engine) this.#render(engine)
        else
            this.#button.setAttribute(
                "aria-label",
                t(getLanguage(this), "audioLanguage")
            )
    }

    #findMedia(): EngineHost | null {
        const player = this.closest("video-player")
        return (player?.querySelector("hls-video") as EngineHost | null) ?? null
    }
}

if (!customElements.get(TAG)) customElements.define(TAG, AudioPickerElement)

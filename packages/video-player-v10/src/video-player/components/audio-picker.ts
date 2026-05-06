import { MediaElement } from "@videojs/html"

const TAG = "bccm-audio-picker"
let popoverIdSeq = 0

// Material-style "translate" / language icon — recognizable as
// "switch language" alongside the (volume-only) mute button.
const ICON_LANGUAGE = `<svg class="media-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 24 24"><path fill="currentColor" d="M12.87 15.07 10.33 12.56l.03-.03A17.5 17.5 0 0 0 14.07 6h2.93V4h-7V2h-2v2h-7v2h11.17a15.5 15.5 0 0 1-3.17 5.32A15.5 15.5 0 0 1 7.41 8H5.41A17.5 17.5 0 0 0 9.34 13.95l-5.13 5.07L5.62 20.4 10.5 15.5l3.04 3.04 1.33-1.47ZM18.5 10h-2L12 22h2l1.12-3h4.75L21 22h2L18.5 10ZM15.88 17l1.62-4.33L19.12 17h-3.24Z"/></svg>`

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
        this.#button.setAttribute("aria-label", "Audio language")
        this.#button.innerHTML = ICON_LANGUAGE

        this.#menu.addEventListener(
            "toggle",
            (e) => {
                if ((e as ToggleEvent).newState === "open") this.#position()
            },
            { signal }
        )

        this.replaceChildren(this.#button, this.#menu)

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
        const active = tracks.find((t) => t.id === engine.audioTrack)
        this.#button.setAttribute(
            "aria-label",
            active
                ? `Audio language: ${active.name || active.lang || "default"}`
                : "Audio language"
        )
        this.toggleAttribute("data-empty", tracks.length <= 1)

        this.#menu.replaceChildren()
        for (const t of tracks) {
            const item = document.createElement("button")
            item.type = "button"
            item.className = "bccm-picker-item"
            item.setAttribute("role", "menuitemradio")
            item.textContent = t.name || t.lang || `Track ${t.id}`
            if (t.id === engine.audioTrack) item.setAttribute("aria-checked", "true")
            item.addEventListener("click", () => {
                engine.audioTrack = t.id
                this.#menu.hidePopover()
            })
            this.#menu.appendChild(item)
        }
    }

    #findMedia(): EngineHost | null {
        const player = this.closest("video-player")
        return (player?.querySelector("hls-video") as EngineHost | null) ?? null
    }

    #position(): void {
        const rect = this.#button.getBoundingClientRect()
        this.#menu.style.position = "fixed"
        this.#menu.style.top = "auto"
        this.#menu.style.left = "auto"
        this.#menu.style.bottom = `${window.innerHeight - rect.top + 8}px`
        this.#menu.style.right = `${window.innerWidth - rect.right}px`
    }
}

if (!customElements.get(TAG)) customElements.define(TAG, AudioPickerElement)

import {
    MediaElement,
    PlayerController,
    playerContext,
    type PropertyValues,
} from "@videojs/html"
import { selectTextTrack } from "@videojs/core/dom"
import { wirePickerKeyboard } from "./picker-keyboard"
import { wirePickerPositioning } from "./picker-position"

const TAG = "bccm-subtitle-picker"
let popoverIdSeq = 0

const ICON_CAPTIONS_OFF = `<svg class="media-icon media-icon--captions-off" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><rect width="16" height="12" x="1" y="3" stroke="currentColor" stroke-width="2" rx="3"/><rect width="3" height="2" x="3" y="8" fill="currentColor" rx="1"/><rect width="2" height="2" x="13" y="8" fill="currentColor" rx="1"/><rect width="4" height="2" x="11" y="11" fill="currentColor" rx="1"/><rect width="5" height="2" x="7" y="8" fill="currentColor" rx="1"/><rect width="7" height="2" x="3" y="11" fill="currentColor" rx="1"/></svg>`
const ICON_CAPTIONS_ON = `<svg class="media-icon media-icon--captions-on" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M15 2a3 3 0 0 1 3 3v8a3 3 0 0 1-3 3H3a3 3 0 0 1-3-3V5a3 3 0 0 1 3-3zM4 11a1 1 0 1 0 0 2h5a1 1 0 1 0 0-2zm8 0a1 1 0 1 0 0 2h2a1 1 0 1 0 0-2zM4 8a1 1 0 0 0 0 2h1a1 1 0 0 0 0-2zm4 0a1 1 0 0 0 0 2h3a1 1 0 1 0 0-2zm6 0a1 1 0 1 0 0 2 1 1 0 0 0 0-2"/></svg>`

export class SubtitlePickerElement extends MediaElement {
    static readonly tagName = TAG

    #textTrack = new PlayerController(this, playerContext, selectTextTrack)
    #disconnect: AbortController | null = null
    #button = document.createElement("button")
    #menu = document.createElement("div")

    connectedCallback(): void {
        super.connectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = new AbortController()
        const { signal } = this.#disconnect

        const popoverId = `bccm-sub-${++popoverIdSeq}`
        this.#menu.id = popoverId
        this.#menu.popover = "auto"
        this.#menu.className = "bccm-picker-menu"
        this.#menu.setAttribute("role", "menu")

        this.#button.type = "button"
        this.#button.className =
            "bccm-picker-button media-button media-button--subtle media-button--icon media-button--captions"
        this.#button.setAttribute("popovertarget", popoverId)
        this.#button.setAttribute("aria-label", "Subtitles")
        this.#button.innerHTML = ICON_CAPTIONS_OFF + ICON_CAPTIONS_ON

        // Native popover handles open/close + outside-click dismiss. Position
        // each time it opens so the menu sits above the trigger button.
        wirePickerPositioning(this.#button, this.#menu, signal)
        wirePickerKeyboard(this.#button, this.#menu, signal)

        this.replaceChildren(this.#button, this.#menu)
    }

    disconnectedCallback(): void {
        super.disconnectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = null
    }

    update(changed: PropertyValues): void {
        super.update(changed)
        const state = this.#textTrack.value
        if (!state) return

        const subs = state.textTrackList.filter(
            (t) => t.kind === "captions" || t.kind === "subtitles"
        )
        const active = subs.find((t) => t.mode === "showing")

        // .media-button--captions reads [data-active] to swap on/off icons
        // (rule lives in skin.css, lifted from the default v10 captions button).
        this.#button.toggleAttribute("data-active", !!active)
        this.#button.setAttribute(
            "aria-label",
            active
                ? `Subtitles: ${active.label || active.language || "on"}`
                : "Subtitles: off"
        )
        this.toggleAttribute("data-empty", subs.length === 0)

        this.#renderMenu(subs)
    }

    #renderMenu(
        subs: { kind: string; label: string; language: string; mode: string }[]
    ): void {
        this.#menu.replaceChildren()

        const off = this.#item("Off", () => this.#applySelection(undefined))
        if (!subs.some((t) => t.mode === "showing")) {
            off.setAttribute("aria-checked", "true")
        }
        this.#menu.appendChild(off)

        for (const t of subs) {
            const item = this.#item(t.label || t.language || "Track", () =>
                this.#applySelection(t.language)
            )
            if (t.mode === "showing") item.setAttribute("aria-checked", "true")
            this.#menu.appendChild(item)
        }
    }

    #item(label: string, onActivate: () => void): HTMLButtonElement {
        const b = document.createElement("button")
        b.type = "button"
        b.setAttribute("tabindex", "-1")
        b.className = "bccm-picker-item"
        b.setAttribute("role", "menuitemradio")
        b.textContent = label
        b.addEventListener("click", () => {
            onActivate()
            this.#menu.hidePopover()
        })
        return b
    }

    #applySelection(language: string | undefined): void {
        const media = this.#findMedia()
        if (!media) return
        const tracks = Array.from(media.textTracks).filter(
            (t) => t.kind === "captions" || t.kind === "subtitles"
        )
        const target = language
            ? tracks.find((t) => t.language?.substring(0, 3) === language)
            : undefined
        for (const t of tracks) {
            t.mode = target && t === target ? "showing" : "disabled"
        }
    }

    #findMedia(): HTMLVideoElement | null {
        const player = this.closest("video-player")
        return (
            (player?.querySelector("hls-video") as HTMLVideoElement | null) ??
            (player?.querySelector("video") as HTMLVideoElement | null)
        )
    }

}

if (!customElements.get(TAG)) customElements.define(TAG, SubtitlePickerElement)

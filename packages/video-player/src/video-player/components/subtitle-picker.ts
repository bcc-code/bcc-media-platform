import {
    MediaElement,
    PlayerController,
    playerContext,
    type PropertyValues,
} from "@videojs/html"
import { selectTextTrack } from "@videojs/core/dom"
import { wirePickerKeyboard } from "./picker-keyboard"
import { wirePickerPositioning } from "./picker-position"
import {
    getLanguage,
    getTrackLanguageName,
    onLanguageChange,
    t,
} from "../i18n/strings"
import ICON_CAPTIONS_OFF from "../skin/icons/captions-off.svg?raw"
import ICON_CAPTIONS_ON from "../skin/icons/captions-on.svg?raw"

const TAG = "bccm-subtitle-picker"
let popoverIdSeq = 0

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
        this.#button.setAttribute(
            "aria-label",
            t(getLanguage(this), "subtitles")
        )
        this.#button.innerHTML = ICON_CAPTIONS_OFF + ICON_CAPTIONS_ON

        // Native popover handles open/close + outside-click dismiss. Position
        // each time it opens so the menu sits above the trigger button.
        wirePickerPositioning(this.#button, this.#menu, signal)
        wirePickerKeyboard(this.#button, this.#menu, signal)

        this.replaceChildren(this.#button, this.#menu)

        onLanguageChange(this, signal, () => this.requestUpdate())
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
        const lang = getLanguage(this)
        this.#button.setAttribute(
            "aria-label",
            active
                ? t(lang, "subtitlesActive", {
                      label:
                          getTrackLanguageName(active.language) ||
                          active.label ||
                          active.language ||
                          t(lang, "off"),
                  })
                : t(lang, "subtitlesOff")
        )
        this.toggleAttribute("data-empty", subs.length === 0)

        this.#renderMenu(subs)
    }

    #renderMenu(
        subs: { kind: string; label: string; language: string; mode: string }[]
    ): void {
        this.#menu.replaceChildren()
        const lang = getLanguage(this)

        const off = this.#item(t(lang, "off"), () =>
            this.#applySelection(undefined)
        )
        if (!subs.some((track) => track.mode === "showing")) {
            off.setAttribute("aria-checked", "true")
        }
        this.#menu.appendChild(off)

        for (const track of subs) {
            const item = this.#item(
                getTrackLanguageName(track.language) ||
                    track.label ||
                    track.language ||
                    t(lang, "subtitleTrackFallback"),
                () => this.#applySelection(track.language)
            )
            if (track.mode === "showing")
                item.setAttribute("aria-checked", "true")
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

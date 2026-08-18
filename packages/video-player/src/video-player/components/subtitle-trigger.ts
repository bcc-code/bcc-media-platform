import {
    MediaElement,
    PlayerController,
    playerContext,
    type PropertyValues,
} from "@videojs/html"
import { selectTextTrack } from "@videojs/core/dom"
import {
    getLanguage,
    getTrackLanguageName,
    onLanguageChange,
    t,
} from "../i18n/strings"
import ICON_CAPTIONS_OFF from "../skin/icons/captions-off.svg?raw"
import ICON_CAPTIONS_ON from "../skin/icons/captions-on.svg?raw"

const TAG = "bccm-subtitle-trigger"

// Trigger only: <media-captions-radio-group> inside the <media-menu> owns the
// track list, the Off entry, keyboard nav and positioning.
export class SubtitleTriggerElement extends MediaElement {
    static readonly tagName = TAG

    #textTrack = new PlayerController(this, playerContext, selectTextTrack)
    #disconnect: AbortController | null = null
    #button = document.createElement("button")

    connectedCallback(): void {
        super.connectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = new AbortController()

        this.#button.type = "button"
        this.#button.className =
            "bccm-picker-button media-button media-button--subtle media-button--icon media-button--captions"
        const menu = this.getAttribute("menu")
        if (menu) this.#button.setAttribute("commandfor", menu)
        this.#button.innerHTML = `${ICON_CAPTIONS_OFF}${ICON_CAPTIONS_ON}`
        this.replaceChildren(this.#button)

        onLanguageChange(this, this.#disconnect.signal, () =>
            this.requestUpdate()
        )
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
            (track) => track.kind === "captions" || track.kind === "subtitles"
        )
        const active = subs.find((track) => track.mode === "showing")
        const lang = getLanguage(this)

        // skin.css swaps the on/off icons off [data-active].
        this.#button.toggleAttribute("data-active", !!active)
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
    }
}

if (!customElements.get(TAG)) customElements.define(TAG, SubtitleTriggerElement)

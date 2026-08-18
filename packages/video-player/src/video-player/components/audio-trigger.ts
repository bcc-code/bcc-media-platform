import {
    MediaElement,
    PlayerController,
    playerContext,
    type PropertyValues,
} from "@videojs/html"
import { selectAudioTrack } from "@videojs/core/dom"
import {
    getLanguage,
    getTrackLanguageName,
    onLanguageChange,
    t,
} from "../i18n/strings"
import ICON_LANGUAGE from "../skin/icons/language.svg?raw"

const TAG = "bccm-audio-trigger"

// Trigger only: <media-audio-track-radio-group> inside the <media-menu> owns
// the track list, keyboard nav and positioning.
export class AudioTriggerElement extends MediaElement {
    static readonly tagName = TAG

    #audio = new PlayerController(this, playerContext, selectAudioTrack)
    #disconnect: AbortController | null = null
    #button = document.createElement("button")

    connectedCallback(): void {
        super.connectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = new AbortController()

        this.#button.type = "button"
        this.#button.className =
            "bccm-picker-button media-button media-button--subtle media-button--icon"
        const menu = this.getAttribute("menu")
        if (menu) this.#button.setAttribute("commandfor", menu)
        this.#button.innerHTML = ICON_LANGUAGE
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
        const state = this.#audio.value
        if (!state) return

        const tracks = state.audioTrackList
        const active = tracks.find((track) => track.enabled)
        const lang = getLanguage(this)

        this.#button.setAttribute(
            "aria-label",
            active
                ? t(lang, "audioLanguageActive", {
                      name:
                          getTrackLanguageName(active.language) ||
                          active.label ||
                          active.language,
                  })
                : t(lang, "audioLanguage")
        )
        this.toggleAttribute("data-empty", tracks.length <= 1)
    }
}

if (!customElements.get(TAG)) customElements.define(TAG, AudioTriggerElement)

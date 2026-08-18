import {
    MediaElement,
    PlayerController,
    playerContext,
    type PropertyValues,
} from "@videojs/html"
import { selectPlaybackRate } from "@videojs/core/dom"
import { getLanguage, onLanguageChange, t } from "../i18n/strings"

const TAG = "bccm-rate-trigger"

// Core's defaults include odd 0.2 / 0.7 stops. The list lives in the player
// store, so it's applied there (see createPlayer) rather than as a prop.
export const PLAYBACK_RATES = [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2]

// Trigger only: <media-playback-rate-radio-group> inside the <media-menu> owns
// the option list, keyboard nav and positioning.
export class RateTriggerElement extends MediaElement {
    static readonly tagName = TAG

    #rate = new PlayerController(this, playerContext, selectPlaybackRate)
    #disconnect: AbortController | null = null
    #button = document.createElement("button")

    connectedCallback(): void {
        super.connectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = new AbortController()

        this.#button.type = "button"
        this.#button.className =
            "bccm-rate-button media-button media-button--subtle"
        const menu = this.getAttribute("menu")
        if (menu) this.#button.setAttribute("commandfor", menu)
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
        const state = this.#rate.value
        if (!state) return
        const rate = formatRate(state.playbackRate)
        this.#button.textContent = `${rate}×`
        this.#button.setAttribute(
            "aria-label",
            t(getLanguage(this), "playbackSpeedActive", { rate })
        )
    }
}

export function formatRate(rate: number): string {
    return Number.isInteger(rate) ? String(rate) : rate.toString()
}

if (!customElements.get(TAG)) customElements.define(TAG, RateTriggerElement)

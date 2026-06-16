import {
    MediaElement,
    PlayerController,
    playerContext,
    type PropertyValues,
} from "@videojs/html"
import { selectControls } from "@videojs/core/dom"
import { getLanguage, onLanguageChange, t } from "../i18n/strings"
import ICON_DISMISS from "../skin/icons/dismiss.svg?raw"

const TAG = "bccm-dismiss-controls-button"

export class DismissControlsButtonElement extends MediaElement {
    static readonly tagName = TAG

    #controls = new PlayerController(this, playerContext, selectControls)
    #disconnect: AbortController | null = null

    connectedCallback(): void {
        super.connectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = new AbortController()
        const { signal } = this.#disconnect

        this.setAttribute("role", "button")
        this.setAttribute("tabindex", "0")
        this.setAttribute("aria-label", t(getLanguage(this), "hideControls"))
        this.className =
            "bccm-dismiss-controls media-button media-button--subtle media-button--icon"
        this.innerHTML = ICON_DISMISS

        this.addEventListener("click", this.#handleActivate, { signal })
        this.addEventListener("keydown", this.#handleKeydown, { signal })

        onLanguageChange(this, signal, (lang) =>
            this.setAttribute("aria-label", t(lang, "hideControls"))
        )
    }

    disconnectedCallback(): void {
        super.disconnectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = null
    }

    update(changed: PropertyValues): void {
        super.update(changed)
        const state = this.#controls.value
        if (!state) return
        // Hide ourselves when controls are already hidden — there's no
        // meaningful target to dismiss.
        this.toggleAttribute("data-hidden", !state.controlsVisible)
    }

    #handleActivate = () => {
        const state = this.#controls.value
        if (state?.controlsVisible) state.toggleControls()
    }

    #handleKeydown = (event: KeyboardEvent) => {
        if (event.key === "Enter" || event.key === " ") {
            event.preventDefault()
            this.#handleActivate()
        }
    }
}

if (!customElements.get(TAG))
    customElements.define(TAG, DismissControlsButtonElement)

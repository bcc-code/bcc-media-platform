import {
    MediaElement,
    PlayerController,
    playerContext,
    type PropertyValues,
} from "@videojs/html"
import { selectControls } from "@videojs/core/dom"
import { getLanguage, onLanguageChange, t } from "../i18n/strings"

const TAG = "bccm-dismiss-controls-button"

// Down-chevron icon — tapping dismisses the control bar overlay so the user
// can see the video. Only useful on smart TVs where there's no mouse to
// trigger the auto-hide-on-idle behavior; the wrapper only renders this
// element when isSmartTV() is true.
const ICON_DISMISS = `<svg class="media-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" aria-hidden="true" viewBox="0 0 18 18"><path fill="currentColor" d="M3.22 6.22a.75.75 0 0 1 1.06 0L9 10.94l4.72-4.72a.75.75 0 0 1 1.06 1.06l-5.25 5.25a.75.75 0 0 1-1.06 0L3.22 7.28a.75.75 0 0 1 0-1.06"/></svg>`

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

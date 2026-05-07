import {
    MediaElement,
    PlayerController,
    playerContext,
    type PropertyValues,
} from "@videojs/html"
import { selectPlaybackRate } from "@videojs/core/dom"
import { wirePickerKeyboard } from "./picker-keyboard"
import { wirePickerPositioning } from "./picker-position"

const TAG = "bccm-playback-rate-picker"
let popoverIdSeq = 0

// v10 core's default rates are [0.2, 0.5, 0.7, 1, 1.2, 1.5, 1.7, 2] (per
// @videojs/core/dom/store/features/playback-rate). Override with the more
// conventional YouTube-style set instead of those quirky 0.2 / 0.7 stops.
const RATES = [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2]

export class PlaybackRatePickerElement extends MediaElement {
    static readonly tagName = TAG

    #playbackRate = new PlayerController(
        this,
        playerContext,
        selectPlaybackRate
    )
    #disconnect: AbortController | null = null
    #button = document.createElement("button")
    #menu = document.createElement("div")

    connectedCallback(): void {
        super.connectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = new AbortController()
        const { signal } = this.#disconnect

        const popoverId = `bccm-rate-${++popoverIdSeq}`
        this.#menu.id = popoverId
        this.#menu.popover = "auto"
        this.#menu.className = "bccm-picker-menu"
        this.#menu.setAttribute("role", "menu")

        this.#button.type = "button"
        this.#button.className =
            "bccm-picker-button bccm-rate-button media-button media-button--subtle"
        this.#button.setAttribute("popovertarget", popoverId)
        this.#button.setAttribute("aria-label", "Playback speed")
        this.#button.textContent = "1\u00d7"

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
        const state = this.#playbackRate.value
        if (!state) return

        this.#button.textContent = `${formatRate(state.playbackRate)}\u00d7`
        this.#button.setAttribute(
            "aria-label",
            `Playback speed: ${formatRate(state.playbackRate)}\u00d7`
        )

        this.#menu.replaceChildren()
        for (const rate of RATES) {
            const item = document.createElement("button")
            item.type = "button"
            item.setAttribute("tabindex", "-1")
            item.className = "bccm-picker-item"
            item.setAttribute("role", "menuitemradio")
            item.textContent = `${formatRate(rate)}\u00d7`
            if (Math.abs(rate - state.playbackRate) < 0.001) {
                item.setAttribute("aria-checked", "true")
            }
            item.addEventListener("click", () => {
                state.setPlaybackRate(rate)
                this.#menu.hidePopover()
            })
            this.#menu.appendChild(item)
        }
    }

}

function formatRate(rate: number): string {
    // Drop trailing zeros: 1.0 -> "1", 1.5 -> "1.5", 1.25 -> "1.25"
    return Number.isInteger(rate) ? String(rate) : rate.toString()
}

if (!customElements.get(TAG))
    customElements.define(TAG, PlaybackRatePickerElement)

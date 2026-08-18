import {
    MediaElement,
    PlayerController,
    playerContext,
    type PropertyValues,
} from "@videojs/html"
import { selectQuality } from "@videojs/core/dom"
import { getLanguage, onLanguageChange, t } from "../i18n/strings"
import ICON_QUALITY from "../skin/icons/quality.svg?raw"

const TAG = "bccm-quality-trigger"

// Trigger only: <media-quality-radio-group> inside the <media-menu> owns the
// rendition list, the Auto entry, keyboard nav and positioning.
export class QualityTriggerElement extends MediaElement {
    static readonly tagName = TAG

    #quality = new PlayerController(this, playerContext, selectQuality)
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
        this.#button.innerHTML = ICON_QUALITY
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
        const state = this.#quality.value
        if (!state) return

        const renditions = state.videoRenditionList
        const height = state.activeVideoRendition?.height
        // No rendition pinned means ABR is picking.
        const isAuto = !renditions.some((rendition) => rendition.selected)
        const lang = getLanguage(this)

        let label: string
        if (!height) label = t(lang, "videoQuality")
        else if (isAuto) label = t(lang, "videoQualityAuto", { height })
        else label = t(lang, "videoQualityActive", { height })
        this.#button.setAttribute("aria-label", label)

        this.toggleAttribute("data-empty", renditions.length <= 1)
    }
}

if (!customElements.get(TAG)) customElements.define(TAG, QualityTriggerElement)

import { MediaElement } from "@videojs/html"
import { getLanguage, onLanguageChange, t } from "../i18n/strings"
import ICON_SETTINGS from "../skin/icons/settings.svg?raw"

const TAG = "bccm-settings-trigger"

// Opens the settings menu. Unlike the per-control triggers it has no state to
// reflect — the submenu rows show their own current values via [data-part=hint].
export class SettingsTriggerElement extends MediaElement {
    static readonly tagName = TAG

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
        this.#button.innerHTML = ICON_SETTINGS
        this.#label()
        this.replaceChildren(this.#button)

        onLanguageChange(this, this.#disconnect.signal, () => this.#label())
    }

    disconnectedCallback(): void {
        super.disconnectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = null
    }

    #label(): void {
        this.#button.setAttribute(
            "aria-label",
            t(getLanguage(this), "settings")
        )
    }
}

if (!customElements.get(TAG)) customElements.define(TAG, SettingsTriggerElement)

import { MediaElement } from "@videojs/html"
import { wirePickerKeyboard } from "./picker-keyboard"
import { wirePickerPositioning } from "./picker-position"
import {
    findTrackHost,
    onTrackHostLoad,
    type VideoRendition,
    type VideoRenditionList,
} from "./media-tracks"
import { getLanguage, onLanguageChange, t } from "../i18n/strings"
import ICON_QUALITY from "../skin/icons/quality.svg?raw"

const TAG = "bccm-quality-picker"
const LIST_EVENTS = [
    "addrendition",
    "removerendition",
    "change",
    "activechange",
]
let popoverIdSeq = 0

export class QualityPickerElement extends MediaElement {
    static readonly tagName = TAG

    #disconnect: AbortController | null = null
    #listAbort: AbortController | null = null
    #list: VideoRenditionList | null = null
    #button = document.createElement("button")
    #menu = document.createElement("div")

    connectedCallback(): void {
        super.connectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = new AbortController()
        const { signal } = this.#disconnect

        const popoverId = `bccm-q-${++popoverIdSeq}`
        this.#menu.id = popoverId
        this.#menu.popover = "auto"
        this.#menu.className = "bccm-picker-menu"
        this.#menu.setAttribute("role", "menu")

        this.#button.type = "button"
        this.#button.className =
            "bccm-picker-button media-button media-button--subtle media-button--icon"
        this.#button.setAttribute("popovertarget", popoverId)
        this.#button.setAttribute(
            "aria-label",
            t(getLanguage(this), "videoQuality")
        )
        this.#button.innerHTML = ICON_QUALITY

        wirePickerPositioning(this.#button, this.#menu, signal)
        wirePickerKeyboard(this.#button, this.#menu, signal)

        this.replaceChildren(this.#button, this.#menu)

        onLanguageChange(this, signal, () => this.#render())
        onTrackHostLoad(this, signal, this.#attach)
    }

    disconnectedCallback(): void {
        super.disconnectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = null
        this.#listAbort?.abort()
        this.#listAbort = null
        this.#list = null
    }

    #attach = (): void => {
        const list = findTrackHost(this)?.videoRenditions
        if (!list || list === this.#list) return
        this.#listAbort?.abort()
        this.#listAbort = new AbortController()
        const { signal } = this.#listAbort
        this.#list = list
        for (const event of LIST_EVENTS) {
            list.addEventListener(event, () => this.#render(), { signal })
        }
        this.#render()
    }

    #render(): void {
        const list = this.#list
        const lang = getLanguage(this)
        if (!list) {
            this.#button.setAttribute("aria-label", t(lang, "videoQuality"))
            return
        }

        const renditions = [...list]
        this.toggleAttribute("data-empty", renditions.length <= 1)

        const isAuto = list.selectedIndex === -1
        const playing = renditions.find((r) => r.active)

        let ariaLabel: string
        if (!playing?.height) {
            ariaLabel = t(lang, "videoQuality")
        } else if (isAuto) {
            ariaLabel = t(lang, "videoQualityAuto", { height: playing.height })
        } else {
            ariaLabel = t(lang, "videoQualityActive", {
                height: playing.height,
            })
        }
        this.#button.setAttribute("aria-label", ariaLabel)

        // Descending by height, keeping the list index for selection.
        const sorted = renditions
            .map((rendition, idx) => ({ rendition, idx }))
            .sort(
                (a, b) => (b.rendition.height ?? 0) - (a.rendition.height ?? 0)
            )

        this.#menu.replaceChildren()

        const auto = this.#item(
            isAuto && playing?.height
                ? t(lang, "autoWithHeight", { height: playing.height })
                : t(lang, "auto"),
            () => {
                list.selectedIndex = -1
            }
        )
        if (isAuto) auto.setAttribute("aria-checked", "true")
        this.#menu.appendChild(auto)

        for (const { rendition, idx } of sorted) {
            const item = this.#item(this.#label(rendition, idx, lang), () => {
                list.selectedIndex = idx
            })
            if (!isAuto && idx === list.selectedIndex) {
                item.setAttribute("aria-checked", "true")
            }
            this.#menu.appendChild(item)
        }
    }

    #label(
        rendition: VideoRendition,
        idx: number,
        lang: ReturnType<typeof getLanguage>
    ): string {
        if (rendition.height) return `${rendition.height}p`
        return t(lang, "qualityLevelFallback", { idx })
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
}

if (!customElements.get(TAG)) customElements.define(TAG, QualityPickerElement)

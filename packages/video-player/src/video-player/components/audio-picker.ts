import { MediaElement } from "@videojs/html"
import { wirePickerKeyboard } from "./picker-keyboard"
import { wirePickerPositioning } from "./picker-position"
import {
    type AudioTrack,
    type AudioTrackList,
    findTrackHost,
    onTrackHostLoad,
} from "./media-tracks"
import {
    getLanguage,
    getTrackLanguageName,
    onLanguageChange,
    t,
} from "../i18n/strings"
import ICON_LANGUAGE from "../skin/icons/language.svg?raw"

const TAG = "bccm-audio-picker"
const LIST_EVENTS = ["addtrack", "removetrack", "change"]
let popoverIdSeq = 0

export class AudioPickerElement extends MediaElement {
    static readonly tagName = TAG

    #disconnect: AbortController | null = null
    #listAbort: AbortController | null = null
    #list: AudioTrackList | null = null
    #button = document.createElement("button")
    #menu = document.createElement("div")

    connectedCallback(): void {
        super.connectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = new AbortController()
        const { signal } = this.#disconnect

        const popoverId = `bccm-aud-${++popoverIdSeq}`
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
            t(getLanguage(this), "audioLanguage")
        )
        this.#button.innerHTML = ICON_LANGUAGE

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
        const list = findTrackHost(this)?.audioTracks
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
        const lang = getLanguage(this)
        const tracks = this.#list ? [...this.#list] : []
        const active = tracks.find((track) => track.enabled)

        const labelFor = (track: AudioTrack, idx: number) =>
            getTrackLanguageName(track.language) ||
            track.label ||
            track.language ||
            t(lang, "audioTrackFallback", { id: track.id ?? idx })

        this.#button.setAttribute(
            "aria-label",
            active
                ? t(lang, "audioLanguageActive", {
                      name: labelFor(active, tracks.indexOf(active)),
                  })
                : t(lang, "audioLanguage")
        )
        this.toggleAttribute("data-empty", tracks.length <= 1)

        this.#menu.replaceChildren()
        tracks.forEach((track, idx) => {
            const item = document.createElement("button")
            item.type = "button"
            item.setAttribute("tabindex", "-1")
            item.className = "bccm-picker-item"
            item.setAttribute("role", "menuitemradio")
            item.textContent = labelFor(track, idx)
            if (track.enabled) item.setAttribute("aria-checked", "true")
            item.addEventListener("click", () => {
                track.enabled = true
                this.#menu.hidePopover()
            })
            this.#menu.appendChild(item)
        })
    }
}

if (!customElements.get(TAG)) customElements.define(TAG, AudioPickerElement)

import { MediaElement } from "@videojs/html"
import { wirePickerKeyboard } from "./picker-keyboard"
import { wirePickerPositioning } from "./picker-position"
import { getLanguage, onLanguageChange, t } from "../i18n/strings"
import ICON_QUALITY from "../skin/icons/quality.svg?raw"

const TAG = "bccm-quality-picker"
let popoverIdSeq = 0

type HlsLevel = {
    height?: number
    width?: number
    bitrate?: number
    name?: string
}
type HlsEngine = {
    levels: HlsLevel[]
    currentLevel: number
    loadLevel: number
    autoLevelEnabled: boolean
    on(event: string, cb: () => void): void
    off(event: string, cb: () => void): void
}
type EngineHost = HTMLElement & { engine?: HlsEngine | null }

// hls.js owns the quality-level list. v10 core does not have a "qualityLevels"
// feature as of @videojs/core@10.0.0-beta.23, so we subscribe to the engine
// directly — same pattern as the audio picker.
export class QualityPickerElement extends MediaElement {
    static readonly tagName = TAG

    #disconnect: AbortController | null = null
    #engineUnsub: (() => void) | null = null
    #button = document.createElement("button")
    #menu = document.createElement("div")
    #pollHandle: ReturnType<typeof setInterval> | null = null

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

        onLanguageChange(this, signal, () => this.#refreshFromEngine())

        this.#waitForEngine()
    }

    disconnectedCallback(): void {
        super.disconnectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = null
        this.#engineUnsub?.()
        this.#engineUnsub = null
        if (this.#pollHandle) clearInterval(this.#pollHandle)
        this.#pollHandle = null
    }

    #waitForEngine(): void {
        const tryAttach = () => {
            const media = this.#findMedia()
            const engine = media?.engine
            if (engine) {
                if (this.#pollHandle) clearInterval(this.#pollHandle)
                this.#pollHandle = null
                this.#attachEngine(engine)
                return true
            }
            return false
        }
        if (tryAttach()) return
        this.#pollHandle = setInterval(tryAttach, 250)
    }

    #attachEngine(engine: HlsEngine): void {
        const refresh = () => this.#render(engine)
        engine.on("hlsLevelsUpdated", refresh)
        engine.on("hlsLevelSwitched", refresh)
        engine.on("hlsManifestParsed", refresh)
        this.#engineUnsub = () => {
            engine.off("hlsLevelsUpdated", refresh)
            engine.off("hlsLevelSwitched", refresh)
            engine.off("hlsManifestParsed", refresh)
        }
        refresh()
    }

    #render(engine: HlsEngine): void {
        const levels = engine.levels ?? []
        this.toggleAttribute("data-empty", levels.length <= 1)

        const isAuto = engine.autoLevelEnabled
        const activeLevel = levels[engine.loadLevel]
        const lang = getLanguage(this)

        let ariaLabel: string
        if (!activeLevel?.height) {
            ariaLabel = t(lang, "videoQuality")
        } else if (isAuto) {
            ariaLabel = t(lang, "videoQualityAuto", {
                height: activeLevel.height,
            })
        } else {
            ariaLabel = t(lang, "videoQualityActive", {
                height: activeLevel.height,
            })
        }
        this.#button.setAttribute("aria-label", ariaLabel)

        // Sort by height descending (highest quality first), preserving the
        // original engine.levels index for selection.
        const sorted = levels
            .map((level, idx) => ({ level, idx }))
            .sort((a, b) => (b.level.height ?? 0) - (a.level.height ?? 0))

        this.#menu.replaceChildren()

        const auto = this.#item(
            isAuto && activeLevel?.height
                ? t(lang, "autoWithHeight", { height: activeLevel.height })
                : t(lang, "auto"),
            () => {
                engine.currentLevel = -1
                this.#menu.hidePopover()
            }
        )
        if (isAuto) auto.setAttribute("aria-checked", "true")
        this.#menu.appendChild(auto)

        for (const { level, idx } of sorted) {
            const label = level.height
                ? `${level.height}p`
                : level.name || t(lang, "qualityLevelFallback", { idx })
            const item = this.#item(label, () => {
                engine.currentLevel = idx
                this.#menu.hidePopover()
            })
            if (!isAuto && idx === engine.currentLevel) {
                item.setAttribute("aria-checked", "true")
            }
            this.#menu.appendChild(item)
        }
    }

    #refreshFromEngine(): void {
        const engine = this.#findMedia()?.engine
        if (engine) this.#render(engine)
        else
            this.#button.setAttribute(
                "aria-label",
                t(getLanguage(this), "videoQuality")
            )
    }

    #item(label: string, onActivate: () => void): HTMLButtonElement {
        const b = document.createElement("button")
        b.type = "button"
        b.setAttribute("tabindex", "-1")
        b.className = "bccm-picker-item"
        b.setAttribute("role", "menuitemradio")
        b.textContent = label
        b.addEventListener("click", onActivate)
        return b
    }

    #findMedia(): EngineHost | null {
        const player = this.closest("video-player")
        return (player?.querySelector("hls-video") as EngineHost | null) ?? null
    }
}

if (!customElements.get(TAG)) customElements.define(TAG, QualityPickerElement)

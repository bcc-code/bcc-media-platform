import { MediaElement } from "@videojs/html"
import { getLanguage, onLanguageChange, t } from "../i18n/strings"

const TAG = "bccm-live-button"

const ICON_DOT = `<span class="bccm-live-badge__dot" aria-hidden="true"></span>`
const BADGE_TEXT = `<span class="bccm-live-badge__text" data-i18n="live"></span>`

type EngineHost = HTMLElement & {
    engine?: { liveSyncPosition?: number | null } | null
}

// liveEdgeStart isn't in the store: the live feature ships in
// liveVideoFeatures, not the default videoFeatures bundle. Read the engine
// directly instead, falling back to the media element's seekable range.
export class LiveButtonElement extends MediaElement {
    static readonly tagName = TAG

    #disconnect: AbortController | null = null
    #button = document.createElement("button")

    connectedCallback(): void {
        super.connectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = new AbortController()
        const { signal } = this.#disconnect

        const lang = getLanguage(this)
        this.#button.type = "button"
        this.#button.className = "bccm-live-badge"
        this.#button.setAttribute("aria-label", t(lang, "goToLive"))
        this.#button.innerHTML = `${ICON_DOT}${BADGE_TEXT}`
        // buildSkin's relabel pass ran before this element upgraded.
        const badgeText = this.#button.querySelector<HTMLElement>(
            ".bccm-live-badge__text"
        )
        if (badgeText) badgeText.textContent = t(lang, "live")
        this.#button.addEventListener("click", () => this.#seekToLive(), {
            signal,
        })

        this.replaceChildren(this.#button)

        onLanguageChange(this, signal, (lang) =>
            this.#button.setAttribute("aria-label", t(lang, "goToLive"))
        )

        // Deferred so closest() can resolve the player ancestor.
        queueMicrotask(() => {
            const media = this.#findMedia()
            if (!media) return
            const update = () => this.#refresh(media)
            media.addEventListener("timeupdate", update, { signal })
            media.addEventListener("seeked", update, { signal })
            media.addEventListener("progress", update, { signal })
            media.addEventListener("loadedmetadata", update, { signal })
            update()
        })
    }

    disconnectedCallback(): void {
        super.disconnectedCallback()
        this.#disconnect?.abort()
        this.#disconnect = null
    }

    #refresh(media: HTMLMediaElement): void {
        const edge = this.#liveEdge(media)
        if (edge == null) return
        // ~one HLS segment of tolerance counts as "at live".
        const atLive = edge - media.currentTime < 3
        this.#button.toggleAttribute("data-at-live", atLive)
    }

    #seekToLive(): void {
        const media = this.#findMedia()
        if (!media) return
        const edge = this.#liveEdge(media)
        if (edge == null) return
        media.currentTime = edge
        if (media.paused) media.play().catch(() => {})
    }

    #liveEdge(media: HTMLMediaElement): number | null {
        const sync = (media as EngineHost).engine?.liveSyncPosition
        if (typeof sync === "number" && Number.isFinite(sync)) return sync
        if (media.seekable && media.seekable.length > 0) {
            return media.seekable.end(media.seekable.length - 1)
        }
        return null
    }

    #findMedia(): HTMLVideoElement | null {
        const player = this.closest("video-player")
        return (
            (player?.querySelector("hlsjs-video") as HTMLVideoElement | null) ??
            (player?.querySelector("video") as HTMLVideoElement | null)
        )
    }
}

if (!customElements.get(TAG)) customElements.define(TAG, LiveButtonElement)

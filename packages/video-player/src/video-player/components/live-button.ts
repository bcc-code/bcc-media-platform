import { MediaElement } from "@videojs/html"
import { getLanguage, onLanguageChange, t } from "../i18n/strings"

const TAG = "bccm-live-button"

const ICON_DOT = `<span class="bccm-live-badge__dot" aria-hidden="true"></span>`
const BADGE_TEXT = `<span class="bccm-live-badge__text" data-i18n="live"></span>`

// `liveEdgeStart` is the Seekable Live Edge: seekable end minus the manifest's
// HOLD-BACK. Not in the store — the live feature ships in liveVideoFeatures,
// not the default videoFeatures bundle — but the media element exposes it.
type LiveHost = HTMLElement & { liveEdgeStart?: number }

// Tolerances copied from LiveButtonCore so this badge agrees with core's own
// live button.
const EDGE_TOLERANCE = 5
const SEEKABLE_END_OFFSET = 10

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
        const edge = this.#liveEdgeStart(media)
        if (edge != null) {
            const atLive = media.currentTime >= edge - EDGE_TOLERANCE
            this.#button.toggleAttribute("data-at-live", atLive)
            return
        }
        const end = this.#seekableEnd(media)
        if (end == null) return
        this.#button.toggleAttribute(
            "data-at-live",
            media.currentTime >= end - SEEKABLE_END_OFFSET
        )
    }

    #seekToLive(): void {
        const media = this.#findMedia()
        if (!media) return
        // Core seeks to the seekable end; we stop at liveEdgeStart, which sits
        // a HOLD-BACK short of it — the same place hls.js's liveSyncPosition
        // did, so we don't start seeking past the buffer.
        const target = this.#liveEdgeStart(media) ?? this.#seekableEnd(media)
        if (target == null) return
        media.currentTime = target
        if (media.paused) media.play().catch(() => {})
    }

    #liveEdgeStart(media: HTMLMediaElement): number | null {
        const edge = (media as LiveHost).liveEdgeStart
        return typeof edge === "number" && Number.isFinite(edge) ? edge : null
    }

    #seekableEnd(media: HTMLMediaElement): number | null {
        const { seekable } = media
        if (!seekable || seekable.length === 0) return null
        const end = seekable.end(seekable.length - 1)
        return Number.isFinite(end) ? end : null
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

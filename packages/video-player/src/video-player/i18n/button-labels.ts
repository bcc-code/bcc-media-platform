// media-tooltip overwrites its own textContent from `triggerEl.getLabel()` on
// every state tick, so translations have to go through each button's `label`
// prop rather than the tooltip DOM. Despite being declared `{ type: String }`
// (attribute parsing only), the prop accepts a `(state) => string` function.

import { getLanguage, t, type StringKey } from "./strings"

// Structural, to stay decoupled from version-pinned v10 types.
type LabelableButton = HTMLElement & {
    label?: unknown
    requestUpdate?: () => void
    seconds?: number
}

// All optional so drift in v10's state shape doesn't break the build.
interface ButtonState {
    ended?: boolean
    paused?: boolean
    muted?: boolean
    fullscreen?: boolean
    pip?: boolean
    castState?: "connected" | "connecting" | string
    direction?: "backward" | "forward"
}

type ButtonSpec = {
    selector: string
    label: (el: LabelableButton, state: ButtonState) => string
}

const SPECS: ButtonSpec[] = [
    {
        selector: "media-play-button",
        label: (el, state) => {
            const lang = getLanguage(el)
            if (state.ended) return t(lang, "replay")
            return t(lang, state.paused ? "play" : "pause")
        },
    },
    {
        selector: "media-mute-button",
        label: (el, state) =>
            t(getLanguage(el), state.muted ? "unmute" : "mute"),
    },
    {
        selector: "media-fullscreen-button",
        label: (el, state) =>
            t(
                getLanguage(el),
                state.fullscreen ? "exitFullscreen" : "enterFullscreen"
            ),
    },
    {
        selector: "media-pip-button",
        label: (el, state) =>
            t(getLanguage(el), state.pip ? "exitPip" : "enterPip"),
    },
    {
        selector: "media-cast-button",
        label: (el, state) => {
            const lang = getLanguage(el)
            if (state.castState === "connected") return t(lang, "stopCasting")
            if (state.castState === "connecting") return t(lang, "connecting")
            return t(lang, "startCasting")
        },
    },
    {
        selector: "media-seek-button",
        label: (el, state) => {
            const lang = getLanguage(el)
            // Attribute fallback only hits before the element has upgraded.
            const raw =
                typeof el.seconds === "number"
                    ? el.seconds
                    : Number(el.getAttribute("seconds") ?? 0)
            const abs = Math.abs(raw)
            const key: StringKey =
                state.direction === "backward" ? "seekBackward" : "seekForward"
            return t(lang, key, { seconds: abs })
        },
    },
]

const ALL_SELECTORS = SPECS.map((s) => s.selector).join(",")
const SPEC_BY_TAG = new Map(
    SPECS.map((s) => [s.selector.toUpperCase(), s] as const)
)

// Weak so a disposed player frees its buttons.
const LABELED = new WeakMap<Element, Set<LabelableButton>>()

/**
 * Install translated `label` closures on every v10 default button under
 * `root`. Call once after the skin DOM is built. The closures resolve the
 * language per invocation, so a language change only needs
 * {@link relabelButtons}, not a reinstall.
 */
export function installButtonLabels(root: Element): void {
    const labeled = new Set<LabelableButton>()
    root.querySelectorAll<LabelableButton>(ALL_SELECTORS).forEach((el) => {
        const spec = SPEC_BY_TAG.get(el.tagName)
        if (!spec) return
        el.label = (state: ButtonState) => spec.label(el, state)
        labeled.add(el)
    })
    LABELED.set(root, labeled)
}

/** Re-render labeled buttons so their tooltips pick up the new language. */
export function relabelButtons(root: Element): void {
    LABELED.get(root)?.forEach((el) => el.requestUpdate?.())
}

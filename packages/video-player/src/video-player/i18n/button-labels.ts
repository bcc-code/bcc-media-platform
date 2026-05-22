// v10's built-in button elements (`<media-play-button>`, `<media-mute-button>`,
// `<media-cast-button>`, `<media-pip-button>`, `<media-fullscreen-button>`,
// `<media-seek-button>`) own their tooltip text: `media-tooltip` subscribes to
// the trigger's `$state` and writes `triggerEl.getLabel()` into its
// `textContent` after every state tick — overwriting any DOM we put inside the
// tooltip. To translate these, hook the documented `label` prop on each button
// core: it accepts either a string or a `(state) => string` function that
// short-circuits the core's hardcoded English fallback.
//
// The property is declared `{ type: String }` in v10's element class, but
// that's only for attribute parsing; JS property assignment of a function
// works (Lit-style setters just store-and-requestUpdate). Reflection isn't
// enabled, so the function isn't serialized back to the DOM as an attribute.

import { getLanguage, t, type StringKey } from "./strings"

// Lit-style ReactiveElement shape we need from v10's button elements. Avoids
// importing the v10 types directly so this file stays decoupled from the
// version-pinned internals.
type LabelableButton = HTMLElement & {
    label?: unknown
    requestUpdate?: () => void
    seconds?: number
}

// Structural shape of the bits of v10 button-core state each spec reads.
// All fields optional so v10's state drifting doesn't break the build.
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
        label: (el, state) => t(getLanguage(el), state.muted ? "unmute" : "mute"),
    },
    {
        selector: "media-fullscreen-button",
        label: (el, state) =>
            t(getLanguage(el), state.fullscreen ? "exitFullscreen" : "enterFullscreen"),
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
            // `seconds` is a v10 reactive Number property post-upgrade; the
            // attribute parse is only hit on the very first call before the
            // element has upgraded.
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

// Tracks the buttons we've installed labels on, scoped per skin root. The set
// of elements stays small (≤7 buttons per player) and refs are weak so a
// disposed player frees them automatically.
const LABELED = new WeakMap<Element, Set<LabelableButton>>()

/**
 * Install translated `label` closures on every v10 default button under
 * `root`. Call once after the skin DOM is built. The closures read the
 * current language each invocation via `getLanguage(el)`, so they don't need
 * to be reinstalled when the language changes — only the buttons need to be
 * told to re-render (see {@link relabelButtons}).
 */
export function installButtonLabels(root: Element): void {
    const labeled = new Set<LabelableButton>()
    root.querySelectorAll<LabelableButton>(ALL_SELECTORS).forEach((el) => {
        const spec = SPEC_BY_TAG.get(el.tagName)
        if (!spec) return
        // Lit reactive properties trigger requestUpdate via the setter, so
        // assigning here is enough — no further wiring required.
        el.label = (state: ButtonState) => spec.label(el, state)
        labeled.add(el)
    })
    LABELED.set(root, labeled)
}

/**
 * Re-trigger an update on every button we labeled so its core re-derives
 * `state.label` via our closure and the tooltip's `$state` subscriber picks
 * up the new translated string. Call from `player.setLanguage()`.
 */
export function relabelButtons(root: Element): void {
    LABELED.get(root)?.forEach((el) => el.requestUpdate?.())
}

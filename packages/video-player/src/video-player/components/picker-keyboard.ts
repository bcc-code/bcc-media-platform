// Wires WAI-ARIA menu keyboard semantics onto a popover menu opened from a
// trigger button. Items are matched by `.bccm-picker-item` (the class every
// picker uses for its menu entries) and must have tabindex="-1" so the
// browser's native Tab traversal skips them.
//
// - Arrow keys roam between items (wrapping)
// - Home / End jump to first / last
// - Enter / Space activate the focused item (native button click)
// - Tab / Shift+Tab close the popover and let the browser advance to the
//   next/prev control button (items are tabindex=-1, so Tab skips them)
// - Escape closes the popover and returns focus to the trigger
// - Opening the popover focuses the aria-checked item, or the first item

const ITEM_SELECTOR = ".bccm-picker-item"

export function wirePickerKeyboard(
    trigger: HTMLElement,
    menu: HTMLElement,
    signal: AbortSignal
): void {
    menu.addEventListener(
        "keydown",
        (event) => {
            if (event.key === "Tab") {
                // Let the browser handle Tab natively. Items are tabindex=-1
                // so the next tab stop is the next control after the picker.
                menu.hidePopover()
                return
            }

            const items = Array.from(
                menu.querySelectorAll<HTMLButtonElement>(ITEM_SELECTOR)
            )
            if (items.length === 0) return

            const current = document.activeElement as HTMLElement | null
            const idx = current
                ? items.indexOf(current as HTMLButtonElement)
                : -1

            switch (event.key) {
                case "ArrowDown":
                    event.preventDefault()
                    items[(idx + 1) % items.length]?.focus()
                    break
                case "ArrowUp":
                    event.preventDefault()
                    items[(idx - 1 + items.length) % items.length]?.focus()
                    break
                case "Home":
                    event.preventDefault()
                    items[0]?.focus()
                    break
                case "End":
                    event.preventDefault()
                    items[items.length - 1]?.focus()
                    break
                case "Escape":
                    event.preventDefault()
                    menu.hidePopover()
                    trigger.focus()
                    break
            }
        },
        { signal }
    )

    const focusInitialItem = () => {
        // rAF defers past the browser's own popover-show focus pass and any
        // pending Lit re-render. queueMicrotask was running before items were
        // present / focusable.
        requestAnimationFrame(() => {
            if (!menu.matches(":popover-open")) return
            const checked = menu.querySelector<HTMLElement>(
                `${ITEM_SELECTOR}[aria-checked="true"]`
            )
            const first = menu.querySelector<HTMLElement>(ITEM_SELECTOR)
            ;(checked ?? first)?.focus()
        })
    }

    menu.addEventListener(
        "toggle",
        (event) => {
            if ((event as ToggleEvent).newState === "open") focusInitialItem()
        },
        { signal }
    )

    // Belt-and-braces: invoking the popovertarget triggers click on the
    // trigger button, but the toggle event fires synchronously inside
    // showPopover() and some browsers haven't yet settled top-layer focus by
    // then. Schedule another focus pass from click as a safety net.
    trigger.addEventListener(
        "click",
        () => {
            if (menu.matches(":popover-open")) focusInitialItem()
        },
        { signal }
    )
}

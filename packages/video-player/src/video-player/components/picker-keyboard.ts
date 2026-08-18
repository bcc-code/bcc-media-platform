// WAI-ARIA menu keyboard semantics for a popover menu. Items must carry
// `.bccm-picker-item` and tabindex="-1" so native Tab traversal skips them.

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
                // No preventDefault: let Tab land on the next control.
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
        // rAF, not queueMicrotask: items aren't focusable until after the
        // browser's popover-show focus pass and any pending Lit re-render.
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

    // Second focus pass: `toggle` fires synchronously inside showPopover(),
    // before some browsers have settled top-layer focus.
    trigger.addEventListener(
        "click",
        () => {
            if (menu.matches(":popover-open")) focusInitialItem()
        },
        { signal }
    )
}

// Anchors a popover menu's bottom-right to the trigger button's top-right with
// a small gap, then clamps it to the viewport so it never overflows on small
// or narrow screens. Repositions on viewport resize while the menu is open.

const MARGIN = 8

function reposition(button: HTMLElement, menu: HTMLElement): void {
    const btn = button.getBoundingClientRect()

    // Reset prior positioning so we can measure the menu's natural size.
    menu.style.position = "fixed"
    menu.style.top = "auto"
    menu.style.left = "auto"
    menu.style.right = "auto"
    menu.style.bottom = "auto"

    const m = menu.getBoundingClientRect()

    let bottom = window.innerHeight - btn.top + MARGIN
    if (window.innerHeight - bottom - m.height < MARGIN) {
        bottom = window.innerHeight - m.height - MARGIN
    }

    let right = window.innerWidth - btn.right
    if (window.innerWidth - right - m.width < MARGIN) {
        right = window.innerWidth - m.width - MARGIN
    }
    if (right < MARGIN) right = MARGIN

    menu.style.bottom = `${bottom}px`
    menu.style.right = `${right}px`
    menu.style.visibility = "visible"
}

export function wirePickerPositioning(
    button: HTMLElement,
    menu: HTMLElement,
    signal: AbortSignal
): void {
    let openCtrl: AbortController | null = null

    menu.addEventListener(
        "toggle",
        (event) => {
            const open = (event as ToggleEvent).newState === "open"
            openCtrl?.abort()
            openCtrl = null
            if (!open) {
                // Restore CSS-default hidden state so the next open also
                // waits for JS positioning before becoming visible.
                menu.style.visibility = ""
                return
            }

            reposition(button, menu)
            openCtrl = new AbortController()
            const onResize = () => reposition(button, menu)
            window.addEventListener("resize", onResize, {
                signal: openCtrl.signal,
            })
        },
        { signal }
    )
}

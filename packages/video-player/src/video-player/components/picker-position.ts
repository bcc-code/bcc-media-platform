// Anchors a popover menu above its trigger, clamped to the viewport. Needs to
// reposition on scroll because position:fixed holds the menu still while the
// trigger moves with the page.

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
                // Re-hide so the next open waits for positioning too.
                menu.style.visibility = ""
                return
            }

            reposition(button, menu)
            openCtrl = new AbortController()
            const onChange = () => reposition(button, menu)
            window.addEventListener("resize", onChange, {
                signal: openCtrl.signal,
            })
            // Capture phase + passive so scroll on any ancestor reaches us.
            window.addEventListener("scroll", onChange, {
                signal: openCtrl.signal,
                capture: true,
                passive: true,
            })
        },
        { signal }
    )
}

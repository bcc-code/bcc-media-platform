export type Theme = "dark" | "light"

export const current = () => {
    const theme = localStorage.getItem("theme") as Theme | null
    let dark = theme === "dark"
    if (!theme) {
        if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
            dark = true
        }
    }

    return dark ? "dark" : ("light" as Theme)
}

export const reload = () => {
    const theme = current()

    const classList = document.documentElement.classList

    if (theme === "dark") {
        if (!classList.contains("dark")) {
            classList.add("dark")
        }
    } else {
        if (classList.contains("dark")) {
            classList.remove("dark")
        }
    }
}

export const set = (theme: Theme) => {
    localStorage.setItem("theme", theme)
    reload()
}

export const toggle = () => {
    if (current() === "dark") {
        set("light")
    } else {
        set("dark")
    }
}

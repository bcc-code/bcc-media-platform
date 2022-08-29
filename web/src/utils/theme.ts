export type Theme = "dark" | "light"

export const reload = () => {
    const theme = localStorage.getItem("theme") as Theme | null
    let dark = theme === "dark"
    if (!theme) {
        if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
            dark = true
        }
    }

    
}
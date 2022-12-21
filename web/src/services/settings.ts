import { useCookies } from "./cookies"

type TSettings = {
    locale: string
}

class Settings implements TSettings {
    private get settings(): TSettings {
        return (
            JSON.parse(localStorage.getItem("settings") ?? "{}") ?? {
                locale: "en",
            }
        )
    }

    private set settings(v) {
        const { accepted } = useCookies()
        if (!accepted.value) return

        localStorage.setItem("settings", JSON.stringify(v))
    }

    public get locale() {
        return this.settings.locale
    }

    public set locale(v) {
        this.settings = {
            ...this.settings,
            locale: v,
        }
    }
}

export default new Settings()

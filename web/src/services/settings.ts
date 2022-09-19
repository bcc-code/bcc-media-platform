

type TSettings = {
    locale: string;
}

class Settings implements TSettings {
    private get settings(): TSettings {
        return JSON.parse(localStorage.getItem("settings") ?? "") ?? {
            locale: "en"
        }
    }

    private set settings(v) {
        localStorage.setItem("settings", JSON.stringify(v))
    }

    public get locale() {
        return this.settings.locale
    }

    public set locale(v) {
        this.settings.locale = v
    }
}

export default new Settings()
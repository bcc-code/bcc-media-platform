import i18n, {
    loadLocaleMessages,
    SUPPORT_LOCALES,
    setLanguage as i18nSetLanguage,
} from "@/i18n"
import { computed, ref } from "vue"
import settings from "./settings"

export type Language = {
    code: string
    name: string
    english?: string
}

const capFirstLetter = (str: string) => {
    return str.charAt(0).toUpperCase() + str.slice(1)
}

const getLanguages: (language: string) => Language[] = (language) => {
    if (typeof Intl.DisplayNames) {
        const displayNames = new Intl.DisplayNames([language], {
            type: "language",
        })
        const enDisplayNames = new Intl.DisplayNames(["en"], {
            type: "language",
        })

        const ls = SUPPORT_LOCALES.map((l) => {
            const name = displayNames.of(l)
            const enName = enDisplayNames.of(l)

            return {
                code: l,
                name: capFirstLetter(name ?? l),
                english: name === enName ? undefined : enName,
            }
        })

        return ls
    }

    return SUPPORT_LOCALES.map((l) => {
        return { code: l, name: l, english: undefined }
    })
}

const getCurrentLanguage = () => {
    const saved = settings.locale
    if (saved && SUPPORT_LOCALES.includes(saved)) {
        return saved
    }

    const navLanguage = navigator.language?.split("-")[0]?.toLowerCase() ?? ""

    if (SUPPORT_LOCALES.includes(navLanguage)) {
        return navLanguage
    }

    return "en"
}

export const languages = ref(getLanguages(getCurrentLanguage()))

export const current = computed(() => {
    return languages.value.find(
        (l) => l.code === getCurrentLanguage()
    ) as Language
})

export const setLanguage = async (l: string) => {
    settings.locale = l

    await loadLocaleMessages(i18n, l)
    i18nSetLanguage(i18n, l)

    languages.value = getLanguages(l)
}

export const init = async () => {
    await setLanguage(current.value.code)
}


export const currentAudioLanguage = computed(() => {
    localStorage.setItem("audioLanguage", localStorage.getItem("audioLanguage") ?? "en");
    var code = localStorage.getItem("audioLanguage");
    return languages.value.find(
        (l) => l.code === code
    ) as Language 
})

export const subtitleLanguage = computed(() => {
    localStorage.setItem("subtitleLanguage", localStorage.getItem("subtitleLanguage") ?? "en");
    var code = localStorage.getItem("subtitleLanguage");
    return languages.value.find(
        (l) => l.code === code
    ) as Language 
})

export const setAudioLanguage = (l: string) => {
    localStorage.setItem("audioLanguage", l);
    languages.value = getLanguages(current.value.code)
}

export const setSubtitleLanguage = (l: string) => {
    localStorage.setItem("subtitleLanguage", l);
    languages.value = getLanguages(current.value.code)
}

export const getNestedLangComputed = (title: string) => {
    switch (title) {
        case 'Site Language':
            return current
        case 'Audio Language':
            return currentAudioLanguage
        case 'Subtitle Language':
            return subtitleLanguage
        default:
            return;
    }
}

export const setNestedLangMethod = (title: string, code: string) => {
    switch (title) {
        case 'Site Language':
            return setLanguage(code)
        case 'Audio Language':
            return setAudioLanguage(code)
        case 'Subtitle Language':
            return setSubtitleLanguage(code)
        default:
            return;
    }
}
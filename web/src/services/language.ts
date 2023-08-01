import i18n, {
    loadLocaleMessages,
    SUPPORT_LOCALES,
    setLanguage as i18nSetLanguage,
} from "@/i18n"
import { computed, ref } from "vue"
import settings from "./settings"
import { analytics } from "./analytics"
import { usePage } from "@/utils/page"

export type Language = {
    code: string
    name: string
    english?: string
}

const capFirstLetter = (str: string) => {
    return str.charAt(0).toUpperCase() + str.slice(1)
}

export const getLanguages: (language: string) => Language[] = (language) => {
    if (typeof Intl.DisplayNames !== "undefined") {
        const displayNames = new Intl.DisplayNames([language], {
            type: "language",
        })

        const ls = SUPPORT_LOCALES.map((l) => {
            const enDisplayNames = new Intl.DisplayNames([l], {
                type: "language",
            })
            const name = displayNames.of(l)
            const enName = enDisplayNames.of(l)

            return {
                code: l,
                name: capFirstLetter(enName ?? l),
                english: capFirstLetter(name ?? l),
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
    if (settings.locale !== l) {
        const { current } = usePage()
        analytics.track("language_changed", {
            pageCode: current.value,
            languageFrom: settings.locale,
            languageTo: l,
        })
        settings.locale = l
        // location.reload()

        if (settings.locale === l) {
            location.reload()
        }
    }
    // await loadLocaleMessages(i18n, l)
    // i18nSetLanguage(i18n, l)

    // languages.value = getLanguages(l)
}

export const init = async () => {
    const l = current.value.code

    await loadLocaleMessages(i18n, l)
    i18nSetLanguage(i18n, l)

    languages.value = getLanguages(l)
}

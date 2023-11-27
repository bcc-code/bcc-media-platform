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
    localizedName?: string
}

const capFirstLetter = (str: string) => {
    return str.charAt(0).toUpperCase() + str.slice(1)
}

export function getLanguage({
    languageCode,
    currentLanguageCode,
}: {
    languageCode: string
    currentLanguageCode: string
}): Language {
    if (typeof Intl.DisplayNames === "undefined") {
        return {
            code: languageCode,
            name: languageCode,
            localizedName: undefined,
        }
    }
    const nativeDisplayName = new Intl.DisplayNames([languageCode], {
        type: "language",
    })
    const baseLanguageDisplayNames = new Intl.DisplayNames(
        [currentLanguageCode],
        {
            type: "language",
        }
    )

    return {
        code: languageCode,
        name: capFirstLetter(
            nativeDisplayName.of(languageCode) ?? languageCode
        ),
        localizedName: capFirstLetter(
            baseLanguageDisplayNames.of(languageCode) ?? languageCode
        ),
    }
}

export function getSupportedLanguages(currentLanguageCode: string) {
    return SUPPORT_LOCALES.map((languageCode) => {
        return getLanguage({ languageCode, currentLanguageCode })
    })
}

const getCurrentLanguage = () => {
    try {
        const saved = settings.locale
        if (saved && SUPPORT_LOCALES.includes(saved)) {
            return saved
        }
    } catch {
        // just ignore. likely in an iframe
    }

    const navLanguage = navigator.language?.split("-")[0]?.toLowerCase() ?? ""

    if (SUPPORT_LOCALES.includes(navLanguage)) {
        return navLanguage
    }

    return "en"
}

export const languages = ref(getSupportedLanguages(getCurrentLanguage()))

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

    languages.value = getSupportedLanguages(l)
}

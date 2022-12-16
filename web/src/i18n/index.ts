import { nextTick, ref } from "vue"
import { createI18n } from "vue-i18n"
import type { I18n, I18nOptions, Locale, Composer } from "vue-i18n"

export const SUPPORT_LOCALES = [
    "en",
    "no",
    "de",
    "es",
    "fi",
    "fr",
    "hu",
    "it",
    "pl",
    "pt",
    "ro",
    "ru",
    "sl",
    "tr",
]

export const loading = ref(false)

export function setup(options: I18nOptions = { locale: "en" }): I18n {
    const i18n = createI18n(options)

    loading.value = true
    loadLocaleMessages(i18n, "en").then(() => {
        setLanguage(i18n, options.locale!)
        loading.value = false
    })

    return i18n
}

export function setLanguage(i18n: I18n, locale: Locale): void {
    ;(i18n.global as Composer).locale.value = locale
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const getResourceMessages = (r: any) => r.default || r

const alternative = (r: string) => {
    switch (r) {
        case "no":
            return "nb"
    }
    return r
}

type Messages = {
    [key: string]: Messages | string
}

const cleanMessages = (messages: Messages) => {
    const result = {} as Messages
    for (const [key, value] of Object.entries(messages)) {
        if (typeof value === "string") {
            if (value) {
                result[key] = value
            }
        } else {
            result[key] = cleanMessages(value)
        }
    }
    return result
}

export async function loadLocaleMessages(i18n: I18n, locale: Locale) {
    const messages = (await import(
        `@/translations/${alternative(locale)}.json`
    ).then(getResourceMessages)) as Messages

    i18n.global.setLocaleMessage(locale, cleanMessages(messages))

    return nextTick()
}

export default setup({
    legacy: false,
    locale: "en",
    fallbackLocale: "en",
    silentTranslationWarn: import.meta.env.PROD,
    silentFallbackWarn: import.meta.env.PROD,
})

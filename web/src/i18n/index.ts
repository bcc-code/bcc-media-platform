import { nextTick, ref } from "vue"
import { createI18n } from "vue-i18n"
import type { I18n, I18nOptions, Locale, Composer } from "vue-i18n"

export const SUPPORT_LOCALES = ["en", "no"]

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

export async function loadLocaleMessages(i18n: I18n, locale: Locale) {
    const messages = await import(`@/translations/${locale === "en" ? "default" : locale}.json`).then(
        getResourceMessages
    )

    i18n.global.setLocaleMessage(locale, messages)

    return nextTick()
}

export default setup({
    legacy: false,
    locale: "en",
    fallbackLocale: "en",
})

import { SUPPORT_LOCALES } from "@/i18n"
import { ref } from "vue"

export type Language = {
    code: string
    name: string
    english?: string
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
                name: name ?? l,
                english: name === enName ? undefined : enName,
            }
        })

        return ls
    }

    return SUPPORT_LOCALES.map((l) => {
        return { code: l, name: l, english: undefined }
    })
}

export const languages = ref(getLanguages("en"))

export default {}

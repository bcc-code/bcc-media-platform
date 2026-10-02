// "Video language" is the language of text burned into the picture, or a
// sign-language rendition — it lives in a separate manifest, so switching it
// means swapping the source URL rather than selecting a track. Mirrors the
// feature in bccm_player (Flutter).

import { getTrackLanguageName, type Lang, t } from "../i18n/strings"

export interface VideoLanguageOption {
    /** Language code of the text in the picture, or `null` for the original
     *  (untranslated) version — matching `Stream.videoLanguage`'s nullability. */
    language: string | null
    /** Manifest to play for this language. */
    src: string
    /** Overrides the name derived from `language`. */
    label?: string
}

// Codes reach us from the API ("nor"), from query params, and from callers;
// treat them case-insensitively and read a blank as "the original".
export function normalizeVideoLanguage(
    value: string | null | undefined
): string | null {
    if (value == null) return null
    const trimmed = value.trim().toLowerCase()
    return trimmed === "" ? null : trimmed
}

// The two-letter and three-letter codes for a language have to compare equal:
// the API gives video languages as "no" / "de", while callers hold whatever
// their own language picker uses — often ISO 639-2 ("nor", "deu"). Intl folds
// every spelling onto one base, bibliographic variants included ("ger", "deu"
// and "de" all land on "de").
export function canonicalVideoLanguage(
    value: string | null | undefined
): string | null {
    const normalized = normalizeVideoLanguage(value)
    if (!normalized) return null
    let base = normalized
    try {
        base = new Intl.Locale(normalized).language
    } catch {
        // Not a well-formed tag; compare it as written.
    }
    // Intl keeps Bokmål and Nynorsk apart from the macrolanguage. BCC content
    // doesn't, and neither does the apps' own language picker.
    return base === "nb" || base === "nn" ? "no" : base
}

// First occurrence of each language wins and order is preserved, the same way
// Flutter's LinkedHashSet over the stream list behaves. Entries without a `src`
// are dropped — there would be nothing to switch to. Languages are compared
// canonically, so a list carrying both "no" and "nor" yields one row.
export function dedupeVideoLanguages(
    options: readonly VideoLanguageOption[]
): VideoLanguageOption[] {
    const seen = new Set<string | null>()
    const out: VideoLanguageOption[] = []
    for (const option of options) {
        if (!option?.src) continue
        const key = canonicalVideoLanguage(option.language)
        if (seen.has(key)) continue
        seen.add(key)
        out.push({
            ...option,
            language: normalizeVideoLanguage(option.language),
        })
    }
    return out
}

export function findVideoLanguageOption(
    options: readonly VideoLanguageOption[],
    language: string | null | undefined
): VideoLanguageOption | undefined {
    const wanted = normalizeVideoLanguage(language)
    const exact = options.find(
        (o) => normalizeVideoLanguage(o.language) === wanted
    )
    if (exact || wanted == null) return exact
    const canonical = canonicalVideoLanguage(wanted)
    return options.find((o) => canonicalVideoLanguage(o.language) === canonical)
}

// The native name of the language ("Norsk"), or the UI language's word for the
// original version when there is no code.
export function videoLanguageLabel(
    option: VideoLanguageOption,
    lang: Lang
): string {
    if (option.label) return option.label
    if (!option.language) return t(lang, "videoLanguageOriginal")
    return getTrackLanguageName(option.language) ?? option.language
}

// Menu radio values are strings. The original version has no code, so it rides
// as the empty string — which is also RadioGroupElement's own default value,
// so an unset group already points at the original.
export function videoLanguageValue(
    language: string | null | undefined
): string {
    return normalizeVideoLanguage(language) ?? ""
}

export function videoLanguageFromValue(value: string): string | null {
    return normalizeVideoLanguage(value)
}

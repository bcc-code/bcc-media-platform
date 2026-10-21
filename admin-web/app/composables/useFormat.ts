/**
 * Locale-aware formatting helpers. The Intl tag comes from the active locale
 * (`nb-NO` / `en-GB`), so dates follow the language chosen in settings rather
 * than a hardcoded one.
 */
export function useFormat() {
  const { localeProperties } = useI18n()

  const localeTag = computed(() => localeProperties.value.language ?? 'nb-NO')

  function formatDate(value?: string | null) {
    if (!value) return '—'
    return new Date(value).toLocaleDateString(localeTag.value, {
      day: 'numeric',
      month: 'short',
      year: 'numeric'
    })
  }

  function formatDateTime(value?: string | null) {
    if (!value) return '—'
    return new Date(value).toLocaleString(localeTag.value, {
      day: 'numeric',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    })
  }

  return { localeTag, formatDate, formatDateTime }
}

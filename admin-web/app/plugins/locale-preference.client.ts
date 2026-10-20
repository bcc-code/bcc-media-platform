/**
 * Remembers the language chosen in settings.
 *
 * Browser-language detection is off (see `nuxt.config.ts`), which also turns
 * off the i18n module's own locale cookie — so the preference is stored the
 * same way as the app's other UI settings instead.
 */
export default defineNuxtPlugin({
  name: 'locale-preference',
  dependsOn: ['i18n:plugin'],
  async setup(nuxtApp) {
    const i18n = nuxtApp.$i18n
    const stored = useLocalStorage<string>('ui:locale', i18n.defaultLocale)

    // find() rather than includes() so the value carries the locale union
    // type; an unknown stored value simply falls back to the default.
    const restored = i18n.localeCodes.value.find((c) => c === stored.value)
    if (restored && restored !== i18n.locale.value) {
      await i18n.setLocale(restored)
    }

    watch(i18n.locale, (value) => {
      stored.value = value
    })
  }
})

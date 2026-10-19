<script setup lang="ts">
const { t, locale, setLocale } = useI18n()

useHead({ title: () => t('settings.title') })

const colorMode = useColorMode()

const themeItems = computed(() => [
  {
    label: t('settings.theme.system'),
    value: 'system',
    icon: 'tabler:device-desktop',
    description: t('settings.theme.systemDescription')
  },
  {
    label: t('settings.theme.light'),
    value: 'light',
    icon: 'tabler:sun',
    description: t('settings.theme.lightDescription')
  },
  {
    label: t('settings.theme.dark'),
    value: 'dark',
    icon: 'tabler:moon',
    description: t('settings.theme.darkDescription')
  }
])

const themePreference = computed({
  get: () => colorMode.preference,
  set: (value) => {
    colorMode.preference = value
  }
})

const languageItems = computed(() => [
  {
    label: t('settings.language.nb'),
    value: 'nb',
    icon: 'tabler:flag',
    description: t('settings.language.nbDescription')
  },
  {
    label: t('settings.language.en'),
    value: 'en',
    icon: 'tabler:flag',
    description: t('settings.language.enDescription')
  }
])

// setLocale persists the choice to the `ui_locale` cookie, so it survives
// reloads and stays per-user rather than per-URL.
const languagePreference = computed({
  get: () => locale.value,
  set: (value) => {
    setLocale(value as 'nb' | 'en')
  }
})
</script>

<template>
  <div class="flex max-w-3xl flex-col gap-10">
    <h1 class="text-heading-2 text-text-default">{{ t('settings.title') }}</h1>

    <section class="flex flex-col gap-4">
      <div>
        <h2 class="text-title-1 text-text-default">
          {{ t('settings.theme.title') }}
        </h2>
        <p class="text-body-3 text-text-muted mt-1">
          {{ t('settings.theme.description') }}
        </p>
      </div>
      <DesignRadioGroup v-model="themePreference" :items="themeItems" />
    </section>

    <section class="flex flex-col gap-4">
      <div>
        <h2 class="text-title-1 text-text-default">
          {{ t('settings.language.title') }}
        </h2>
        <p class="text-body-3 text-text-muted mt-1">
          {{ t('settings.language.description') }}
        </p>
      </div>
      <DesignRadioGroup v-model="languagePreference" :items="languageItems" />
    </section>

    <section class="border-border-1 border-t pt-6">
      <NuxtLink
        to="/design"
        class="text-body-3 text-text-hint hover:text-text-default inline-flex items-center gap-2"
      >
        <Icon name="tabler:palette" class="size-4" />
        {{ t('settings.designSystem') }}
      </NuxtLink>
    </section>
  </div>
</template>

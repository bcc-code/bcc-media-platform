<script setup lang="ts">
useHead({ title: 'Innstillinger' })

const colorMode = useColorMode()
const { brand, brands } = useBrand()

const themeItems = [
  {
    label: 'System',
    value: 'system',
    icon: 'tabler:device-desktop',
    description: 'Følg enhetens innstilling'
  },
  {
    label: 'Lys',
    value: 'light',
    icon: 'tabler:sun',
    description: 'Alltid lyst tema'
  },
  {
    label: 'Mørk',
    value: 'dark',
    icon: 'tabler:moon',
    description: 'Alltid mørkt tema'
  }
]

const themePreference = computed({
  get: () => colorMode.preference,
  set: (value) => {
    colorMode.preference = value
  }
})

const swatchFor = (b: BrandInfo) =>
  colorMode.value === 'dark' ? b.swatch.dark : b.swatch.light
</script>

<template>
  <div class="flex max-w-3xl flex-col gap-10">
    <h1 class="text-heading-2 text-text-default">Innstillinger</h1>

    <section class="flex flex-col gap-4">
      <div>
        <h2 class="text-title-1 text-text-default">Tema</h2>
        <p class="text-body-3 text-text-muted mt-1">
          Velg mellom lyst og mørkt tema, eller la systemet bestemme.
        </p>
      </div>
      <DesignRadioGroup v-model="themePreference" :items="themeItems" />
    </section>

    <section class="flex flex-col gap-4">
      <div>
        <h2 class="text-title-1 text-text-default">Farger</h2>
        <p class="text-body-3 text-text-muted mt-1">
          Velg hvilken fargepalett som skal brukes.
        </p>
      </div>
      <DesignRadioGroup v-model="brand" :items="brands">
        <template #leading="{ item }">
          <span
            class="border-border-1 size-4 shrink-0 rounded-full border"
            :style="{ backgroundColor: swatchFor(item) }"
          />
        </template>
      </DesignRadioGroup>
    </section>
  </div>
</template>

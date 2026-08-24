<script setup lang="ts">
useHead({ title: 'Ny short' })

const route = useRoute()
const { add } = useShorts()
const toaster = useToast()

const status = ref<Status>('draft')

// Allows /shorts/new?episode=3 from an episode page.
const presetEpisodeId = computed(() =>
  typeof route.query.episode === 'string' ? route.query.episode : undefined
)

function handleSubmit(short: Short) {
  add(short)
  toaster.value.success({
    title: 'Short opprettet',
    description: 'Klippet ble lagret.'
  })
  navigateTo('/shorts')
}
</script>

<template>
  <div class="flex max-w-3xl flex-col gap-8">
    <div>
      <BackButton to="/shorts" label="Tilbake til shorts" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">Ny short</h1>
        <StatusSelector v-model="status" />
      </div>
    </div>

    <ShortForm
      v-model:status="status"
      :preset-episode-id="presetEpisodeId"
      @submit="handleSubmit"
    />
  </div>
</template>

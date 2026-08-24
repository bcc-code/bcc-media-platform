<script setup lang="ts">
useHead({ title: 'Ny episode' })

const { add } = useEpisodes()
const toaster = useToast()

const status = ref<Status>('draft')

function handleSubmit(data: Episode) {
  add(data)
  toaster.value.success({
    title: 'Episode opprettet',
    description: 'Episoden ble lagret.'
  })
  navigateTo('/episodes')
}
</script>

<template>
  <div class="flex max-w-3xl flex-col gap-8">
    <div>
      <BackButton to="/episodes" label="Tilbake til episoder" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">Ny episode</h1>
        <StatusSelector v-model="status" />
      </div>
    </div>

    <EpisodeForm v-model:status="status" @submit="handleSubmit" />
  </div>
</template>

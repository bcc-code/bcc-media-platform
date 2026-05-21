<script setup lang="ts">
useHead({ title: 'Ny sesong' })

const { add } = useSeasons()
const toaster = useToast()

const status = ref<Status>('draft')

function handleSubmit(season: Season) {
  add(season)
  toaster.value.success({
    title: 'Sesong opprettet',
    description: 'Den nye sesongen ble opprettet.'
  })
  navigateTo('/seasons')
}
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div>
      <BackButton to="/seasons" label="Tilbake til sesonger" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">Ny sesong</h1>
        <StatusSelector v-model="status" />
      </div>
    </div>

    <SeasonForm v-model:status="status" @submit="handleSubmit" />
  </div>
</template>

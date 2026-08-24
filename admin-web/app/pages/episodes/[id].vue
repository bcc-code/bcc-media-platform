<script setup lang="ts">
const route = useRoute()
const { episodes, update, remove } = useEpisodes()
const toaster = useToast()

const episode = computed(() =>
  episodes.value.find((e) => e.id === route.params.id)
)

useHead({ title: () => episode.value?.title ?? 'Rediger episode' })

const status = ref<Status>(episode.value?.status ?? 'draft')
watch(
  () => episode.value?.status,
  (value) => {
    if (value) status.value = value
  }
)

function handleSubmit(data: Episode) {
  update(data.id, data)
  toaster.value.success({
    title: 'Episode oppdatert',
    description: 'Endringene ble lagret.'
  })
  navigateTo('/episodes')
}

function handleDelete() {
  remove(route.params.id as string)
  toaster.value.success({
    title: 'Episode slettet',
    description: 'Episoden ble fjernet.'
  })
  navigateTo('/episodes')
}
</script>

<template>
  <div v-if="episode" class="flex max-w-3xl flex-col gap-8">
    <div>
      <BackButton to="/episodes" label="Tilbake til episoder" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">Rediger episode</h1>
        <StatusSelector v-model="status" />
      </div>
    </div>

    <EpisodeForm
      v-model:status="status"
      :episode="episode"
      @submit="handleSubmit"
      @delete="handleDelete"
    />
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Episoden ble ikke funnet.
  </div>
</template>

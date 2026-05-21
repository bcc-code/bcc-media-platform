<script setup lang="ts">
const route = useRoute()
const { seasons, update, remove } = useSeasons()
const toaster = useToast()

const season = computed(() =>
  seasons.value.find((s) => s.id === route.params.id)
)

const status = ref<Status>(season.value?.status ?? 'draft')
watch(
  () => season.value?.status,
  (value) => {
    if (value) status.value = value
  }
)

useHead({ title: () => season.value?.title ?? 'Rediger sesong' })

function handleSubmit(data: Season) {
  update(data.id, data)
  toaster.value.success({
    title: 'Sesong oppdatert',
    description: 'Endringene ble lagret.'
  })
  navigateTo('/seasons')
}

function handleDelete() {
  remove(route.params.id as string)
  toaster.value.success({
    title: 'Sesong slettet',
    description: 'Sesongen ble fjernet.'
  })
  navigateTo('/seasons')
}
</script>

<template>
  <div v-if="season" class="flex max-w-5xl flex-col gap-8">
    <div>
      <BackButton to="/seasons" label="Tilbake til sesonger" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">Rediger sesong</h1>
        <StatusSelector v-model="status" />
      </div>
    </div>

    <SeasonForm
      v-model:status="status"
      :season="season"
      @submit="handleSubmit"
      @delete="handleDelete"
    />
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Sesongen ble ikke funnet.
  </div>
</template>

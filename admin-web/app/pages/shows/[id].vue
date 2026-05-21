<script setup lang="ts">
const route = useRoute()
const { shows, update, remove } = useShows()
const toaster = useToast()

const show = computed(() => shows.value.find((s) => s.id === route.params.id))

const status = ref<Status>(show.value?.status ?? 'draft')
watch(
  () => show.value?.status,
  (value) => {
    if (value) status.value = value
  }
)

useHead({ title: () => show.value?.title ?? 'Rediger serie' })

function handleSubmit(data: Show) {
  update(data.id, data)
  toaster.value.success({
    title: 'Serie oppdatert',
    description: 'Endringene ble lagret.'
  })
  navigateTo('/shows')
}

function handleDelete() {
  remove(route.params.id as string)
  toaster.value.success({
    title: 'Serie slettet',
    description: 'Serien ble fjernet.'
  })
  navigateTo('/shows')
}
</script>

<template>
  <div v-if="show" class="flex max-w-5xl flex-col gap-8">
    <div>
      <BackButton to="/shows" label="Tilbake til serier" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">Rediger serie</h1>
        <StatusSelector v-model="status" />
      </div>
    </div>

    <ShowForm
      v-model:status="status"
      :show="show"
      @submit="handleSubmit"
      @delete="handleDelete"
    />
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Serien ble ikke funnet.
  </div>
</template>

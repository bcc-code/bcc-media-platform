<script setup lang="ts">
const route = useRoute()
const { shorts, update, remove } = useShorts()
const toaster = useToast()

const short = computed(() => shorts.value.find((s) => s.id === route.params.id))

useHead({ title: () => short.value?.title ?? 'Rediger short' })

const status = ref<Status>(short.value?.status ?? 'draft')
watch(
  () => short.value?.status,
  (value) => {
    if (value) status.value = value
  }
)

function handleSubmit(data: Short) {
  update(data.id, data)
  toaster.value.success({
    title: 'Short oppdatert',
    description: 'Endringene ble lagret.'
  })
  navigateTo('/shorts')
}

function handleDelete() {
  remove(route.params.id as string)
  toaster.value.success({ title: 'Short slettet' })
  navigateTo('/shorts')
}
</script>

<template>
  <div v-if="short" class="flex max-w-3xl flex-col gap-8">
    <div>
      <BackButton to="/shorts" label="Tilbake til shorts" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">Rediger short</h1>
        <StatusSelector v-model="status" />
      </div>
    </div>

    <ShortForm
      v-model:status="status"
      :short="short"
      @submit="handleSubmit"
      @delete="handleDelete"
    />
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Shorten ble ikke funnet.
  </div>
</template>

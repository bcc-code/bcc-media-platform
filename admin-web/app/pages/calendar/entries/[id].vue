<script setup lang="ts">
const route = useRoute()
const { calendarEntries, update, remove } = useCalendarEntries()
const toaster = useToast()

const entry = computed(() =>
  calendarEntries.value.find((e) => e.id === route.params.id)
)

useHead({ title: () => entry.value?.title ?? 'Rediger oppføring' })

function handleSubmit(data: CalendarEntry) {
  update(data.id, data)
  toaster.value.success({
    title: 'Oppføring oppdatert',
    description: 'Endringene ble lagret.'
  })
  navigateTo('/calendar/entries')
}

function handleDelete() {
  remove(route.params.id as string)
  toaster.value.success({
    title: 'Oppføring slettet',
    description: 'Kalenderoppføringen ble fjernet.'
  })
  navigateTo('/calendar/entries')
}
</script>

<template>
  <div v-if="entry" class="flex max-w-5xl flex-col gap-8">
    <div>
      <BackButton to="/calendar/entries" label="Tilbake til oppføringer" />
      <h1 class="text-heading-2 text-text-default">Rediger oppføring</h1>
    </div>

    <CalendarEntryForm
      :entry="entry"
      @submit="handleSubmit"
      @delete="handleDelete"
    />
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Oppføringen ble ikke funnet.
  </div>
</template>

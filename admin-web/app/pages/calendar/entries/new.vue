<script setup lang="ts">
useHead({ title: 'Ny oppføring' })

const { add } = useCalendarEntries()
const toaster = useToast()

const status = ref<Status>('draft')

function handleSubmit(entry: CalendarEntry) {
  add(entry)
  toaster.value.success({
    title: 'Oppføring opprettet',
    description: 'Den nye kalenderoppføringen ble opprettet.'
  })
  navigateTo('/calendar/entries')
}
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div>
      <BackButton to="/calendar/entries" label="Tilbake til oppføringer" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">Ny oppføring</h1>
        <StatusSelector v-model="status" />
      </div>
    </div>

    <CalendarEntryForm v-model:status="status" @submit="handleSubmit" />
  </div>
</template>

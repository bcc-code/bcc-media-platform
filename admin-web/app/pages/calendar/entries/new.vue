<script setup lang="ts">
useHead({ title: 'Ny oppføring' })

const { add } = useCalendarEntries()
const toaster = useToast()

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
      <h1 class="text-heading-2 text-text-default">Ny oppføring</h1>
    </div>

    <CalendarEntryForm @submit="handleSubmit" />
  </div>
</template>

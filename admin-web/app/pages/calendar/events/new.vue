<script setup lang="ts">
useHead({ title: 'Ny hendelse' })

const { add } = useCalendarEvents()
const toaster = useToast()

function handleSubmit(event: CalendarEvent) {
  add(event)
  toaster.value.success({
    title: 'Hendelse opprettet',
    description: 'Den nye hendelsen ble opprettet.'
  })
  navigateTo('/calendar/events')
}
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div>
      <BackButton to="/calendar/events" label="Tilbake til hendelser" />
      <h1 class="text-heading-2 text-text-default">Ny hendelse</h1>
    </div>

    <CalendarEventForm @submit="handleSubmit" />
  </div>
</template>
